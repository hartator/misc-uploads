def try_even
	wait = true
	while (wait == true)
		begin
		    yield
			wait = false
		rescue Selenium::WebDriver::Error::ElementNotDisplayedError
		rescue Selenium::WebDriver::Error::ObsoleteElementError
		rescue Watir::Exception::UnknownObjectException
		rescue Timeout::Error
		ensure
			sleep 1
		end
	end
end
def try_while
	try_until { not(yield) }
end
def try_until
	wait = true
	while (wait == true)
		begin
		    if (yield == true)
				wait = false
			end
		rescue Selenium::WebDriver::Error::ElementNotDisplayedError
		rescue Selenium::WebDriver::Error::ObsoleteElementError
		rescue Watir::Exception::UnknownObjectException
		rescue Timeout::Error
		ensure
			sleep 1
		end
	end
end	
def try_once
	begin
	    yield
	rescue Selenium::WebDriver::Error::ElementNotDisplayedError
	rescue Selenium::WebDriver::Error::ObsoleteElementError
    rescue Watir::Exception::UnknownObjectException
	rescue Timeout::Error
	end
end	
def try_login
	begin
	    if yield == false
			raise 'login failed'
		end
	rescue Selenium::WebDriver::Error::ElementNotDisplayedError, Selenium::WebDriver::Error::ObsoleteElementError, Watir::Exception::UnknownObjectException, Timeout::Error, Watir::Exception::UnknownFrameException
		raise 'login failed'
	end
end
def try_connect
	begin
	    yield
	rescue Selenium::WebDriver::Error::ElementNotDisplayedError, Selenium::WebDriver::Error::ObsoleteElementError, Watir::Exception::UnknownObjectException, Timeout::Error
		raise 'site down'
	end
end
def removeacc(str)
	str.mb_chars.normalize(:kd).gsub(/[^\x00-\x7F]/n,'').to_s
end
def custom_error(str)
		raise str
end