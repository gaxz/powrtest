class TestController < ApplicationController

    def index
        @a = GithubApi.new
    end
end
