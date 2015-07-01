class User < ActiveRecord::Base
	attr_accessor :password

	validates_presence_of :first_name, :last_name, :email, :zipcode
	validates_presence_of     :password,                   :if => :password_required

	validates_uniqueness_of   :email,    :case_sensitive => false
	validates_format_of       :email,    :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
	validates :zipcode, length: { is: 6 }

	before_save :encrypt_password, :if => :password_required

	##
	# This method is for authentication purpose.
	#

	def attributes
		{id: id, first_name: first_name, last_name: last_name, email: email, zipcode: zipcode}
	end

	def self.authenticate(email, password)
		account = where("lower(email) = lower(?)", email).first if email.present?
		account && account.has_password?(password) ? account : nil
	end

	def has_password?(password)
		::BCrypt::Password.new(crypted_password) == password
	end

	private

	def encrypt_password
		value = ::BCrypt::Password.create(password)
		value = value.force_encoding(Encoding::UTF_8) if value.encoding == Encoding::ASCII_8BIT
		self.crypted_password = value
	end

	def password_required
		crypted_password.blank? || password.present?
	end
end
