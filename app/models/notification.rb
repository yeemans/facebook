class Notification < ApplicationRecord
    belongs_to :notifier, class_name: "User"
    belongs_to :receiver, class_name: "User"
end
