class Setting < ApplicationRecord

    def self.getValue(name)
        obj = self.where(name: name).first
        return obj.value
    end
end
