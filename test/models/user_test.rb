require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup
		@user = User.new(name: "ExampleUser", email: "user@example.com", 
			password: "foobar", password_confirmation: "foobar", role: "user")
	end

	test "should be valid" do 
		assert @user.valid?
	end

	test "name should be present" do
		@user.name = "     "
		assert_not @user.valid?
	end

	test "email should be present" do
		@user.email = "     "
		assert_not @user.valid?
	end

	test "user name not too long" do
		@user.name = "a" * 51
		assert_not @user.valid?
	end

	test "user email not too long" do
		@user.email = "a" * 244 + "@example.com"
		assert_not @user.valid?
	end

	test "email validation should accept valid addresses" do
		    valid_addresses = %w[ test@example.com USER@foo.COM A_US-ER@foo.bar.org
			first.last@foo.jp alice+bob@baz.cn ]
			valid_addresses.each do |valid_address|
				@user.email = valid_address
				assert @user.valid?, "#{valid_address.inspect} should be valid"
		end
	end

	test "email validation should reject invalid addresses" do
		invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
			foo@bar_baz.com foo@bar+baz.com]
		invalid_addresses.each do |invalid_address|
			@user.email = invalid_address
			assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
		end
	end

	test "email addresses should be unique" do
	    duplicate_user = @user.dup
	    duplicate_user.email = @user.email.upcase
	    @user.save
	    assert_not duplicate_user.valid?
	end

	test "password should be present (nonblank)" do
	   @user.password = @user.password_confirmation = " " * 6
	   assert_not @user.valid?
	 end

	 test "password should have a minimum length" do
	   @user.password = @user.password_confirmation = "a" * 5
	   assert_not @user.valid?
	 end

	 test "user without a role shoudl be invalid" do
	   @user.role = "     "
	   assert_not @user.valid?
	end

	test "user validation should accept valid roles" do
		valid_roles = %w[ admin user owner ]
		valid_roles.each do |valid_role|
			@user.role = valid_role
			assert @user.valid?, "#{valid_role.inspect} should be valid"
		end
	end
end
