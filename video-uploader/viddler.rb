def viddler
	try_connect { firefox.goto('http://www.viddler.com') }
	firefox.link(:id=>"headerLogin").click
	try_until { firefox.text_field(:id=>"login-username").visible? }
	firefox.text_field(:id=>'login-username').set login
	firefox.execute_script("document.getElementById('login-password').style.display='inline';")
	firefox.text_field(:id=>'login-password').set password
	firefox.link(:id=>'headerLoginSubmit').click
	firefox.goto('http://www.viddler.com/'+login+'/simpleupload/')
	try_login { firefox.file_field(:id=>'upload-browse').set upload.mov.path }
	firefox.text_field(:id=>'upload-title').set removeacc(upload.title_rand)
	firefox.text_field(:id=>'upload-description').set removeacc(upload.description_rand)
	firefox.text_field(:id=>'upload-tags').set removeacc(upload.keywords_comma_rand)
	firefox.checkbox(:id=>'upload-permissions').set
	try_once { firefox.button(:value=>'Upload Video').click }
	try_until { firefox.text.include? 'We are now encoding your video!'}
end