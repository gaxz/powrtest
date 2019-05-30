# Class Setting
# 
# Storing app settings
#
# @id string
# @name string unique
# @value string
#
class Setting < ApplicationRecord

    def self.getValue(name)
        obj = self.where(name: name).first
        return obj.value
    end
end
