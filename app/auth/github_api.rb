class GithubApi

    attr_reader :access_token

    def initialize(client, secret, code, redirect_uri)
        @client = client
        @secret = secret
        @session_code = code
        @redirect_uri = redirect_uri
    end

    # Call api for authorization token and scope
    # @return boolean
    def authenticate
        header = {'Content-Type': 'text/json'}

        params = "?client_id=#{@client}&client_secret=#{@secret}&code=#{@session_code}&redirect_uri=#{@redirect_uri}"
        uri = URI.parse("https://github.com/login/oauth/access_token#{params}")

        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.request_uri, header)
        
        http.use_ssl = (uri.scheme == "https")
        response = http.request(request)

        @access_token = Rack::Utils.parse_nested_query(response.body)['access_token']
        @scope = Rack::Utils.parse_nested_query(response.body)['scope']

        self.validate_response
    end

    # Validate api response
    # @return boolean 
    def validate_response()
        (!@access_token.blank?) && (!@scope.blank?) && (@scope.include? "user:email")
    end

    # Get user info
    # @return object
    def get_user_data
        response = URI.parse("https://api.github.com/user?access_token=#{@access_token}&redirect_uri=#{@redirect_uri}").read
        JSON.parse(response)
    end
end