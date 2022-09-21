FactoryBot.define do
    time = Time.new

    sequence :string, aliases: [:first_name, :last_name, :password, :avatar, :name, :description, :state] do |n|
      "string#{n}"
    end

    sequence :email do |n|
        "person#{n}@example.com"
    end

    sequence :type do |n|
        ""
    end

    sequence :expired_at do |n|
        time.strftime("%Y-%m-%d")
    end
  end