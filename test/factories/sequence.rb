FactoryBot.define do
  time = Time.new

  sequence :string, aliases: [:first_name, :last_name, :password, :avatar, :name, :description] do |n|
    "string#{n}"
  end

  sequence :email do |n|
    "person#{n}@example.com"
  end

  sequence :type do |_n|
    ''
  end

  sequence :expired_at do |_n|
    time.strftime('%Y-%m-%d')
  end
end
