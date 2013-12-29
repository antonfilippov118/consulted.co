class User

end

describe User do

  400.times do
    it "exists" do
      User.is_a? Class
    end
  end
end
