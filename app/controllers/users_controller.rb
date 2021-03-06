class UsersController < ApplicationController

    def callback_uri
        URI.parse(url_for(:action => 'login', :only_path => false))
    end

    def index
        if session[:access_token]
            redirect_to :action => 'info'
        end

        @callback_uri = self.callback_uri
        @client = Setting.getValue('github-client-id')
    end


    def login
        session_code = request.env['rack.request.query_hash']['code']

        if session_code.blank?
            @error = "Authorization code is missing"
            return
        end

        client = Setting.getValue('github-client-id')
        secret = Setting.getValue('github-secret') 
        
        api = GithubApi.new(client, secret, session_code, self.callback_uri)

        if api.authenticate && user_data = api.get_user_data

            # Create user or update access token if already exists
            # It appears github provides only public email from github account options
            # in most cases it will be empty
            if User.exists?(name: user_data['login'])
                user = User.find_by(name: user_data['login'])
                user.access_token = api.access_token
                
                if(!user.save)
                    @error = "User update error"
                    return
                end
            else
                user = User.create(name: user_data['login'], email: user_data['email'], access_token: api.access_token)
                
                if user.new_record?
                    @error = "User create error"
                    return
                end
            end

            session[:access_token] = api.access_token
            
            redirect_to :action => 'info'
            return
        else 
            @error = "Api authentication error"
        end
    end

    def info
        @user = User.find_by(access_token: session[:access_token])
        if @user.blank?
            redirect_to :action => 'index'
        end
    end

    def logout
        session.delete(:access_token)
        redirect_to :action => 'index'
    end
end
