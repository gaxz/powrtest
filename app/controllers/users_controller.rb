class UsersController < ApplicationController

    def index
        @client = Setting.getValue('github-client-id')
    end

    def login

    end
end
