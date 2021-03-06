# == Schema Information
#
# Table name: ivr_connections
#
#  id               :integer          not null, primary key
#  remote_id        :string
#  call_id          :integer
#  legislator_id    :integer
#  status_from_user :string
#  status           :string
#  duration         :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Ivr::Connection < ActiveRecord::Base
  belongs_to :call, required: true, class_name: 'Ivr::Call'
  belongs_to :legislator, required: true
  has_many :campaigns, through: :legislator
  delegate :person, to: :call

  USER_RESPONSE_CODES = {
    '1' => 'success',
    '2' => 'failed',
  }

  scope :uncompleted, -> { where(status: nil, remote_id: nil) }
  scope :completed, -> { 
    where(status: Ivr::Call::CALL_STATUSES[:completed], status_from_user: USER_RESPONSE_CODES['1']) 
  }

  def connecting_message_key
    if legislator.senator?
      'connecting_to_senator'
    else
      if person.constituent_of?(legislator)
        'connecting_to_rep_local'
      else
        'connecting_to_rep'
      end
    end
  end

end
