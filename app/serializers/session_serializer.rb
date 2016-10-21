class SessionSerializer < ActiveModel::Serializer
  FORMAT_DURATION_ATTRIBUTES = [:max_airtime, :total_airtime, :duration]
  attributes(*FORMAT_DURATION_ATTRIBUTES)

  attributes :woo_id, :highest_jump, :total_height, :number_of_jumps, :description, :max_crash_power, :likes, :comments, :finished_at, :picture_url, :user

  has_one :spot, foreign_key: 'spot_woo_id', primary_key: 'woo_id'
  has_one :user, foreign_key: 'user_woo_id', primary_key: 'woo_id'

  FORMAT_DURATION_ATTRIBUTES.each do |attr|
    define_method(attr) { format_duration(object.send(attr)) }
  end

  private

  def finished_at_timestamp
    object.finished_at.to_i * 1000
  end

  def format_duration(seconds)
    time = Time.new(2016,01,01,0,0) + seconds
    if seconds < 60
      time.strftime('%-S.%1Ns')
    elsif seconds < 3600
      time.strftime('%-Mm %-Ss')
    else
      time.strftime('%-kh %-Mm %-Ss')
    end
  end
end
