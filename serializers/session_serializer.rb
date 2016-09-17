class SessionSerializer < ActiveModel::Serializer
  FORMAT_DURATION_ATTRIBUTES = [:max_airtime, :total_airtime, :duration]
  FORMAT_DATETIME_ATTRIBUTES = [:posted_at, :finished_at]
  attributes(*FORMAT_DURATION_ATTRIBUTES)
  attributes(*FORMAT_DATETIME_ATTRIBUTES)

  attributes :woo_id, :highest_jump, :total_height, :number_of_jumps, :description, :max_crash_power, :likes, :comments, :user_name

  has_many :pictures
  has_one :spot, foreign_key: 'spot_woo_id', primary_key: 'woo_id'

  FORMAT_DURATION_ATTRIBUTES.each do |attr|
    define_method(attr) { format_duration(object.send(attr)) }
  end

  FORMAT_DATETIME_ATTRIBUTES.each do |attr|
    define_method(attr) { format_datetime(object.send(attr)) }
  end

  private

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

  def format_datetime(datetime)
    datetime.strftime('%a %b %d, %k:%M')
  end
end
