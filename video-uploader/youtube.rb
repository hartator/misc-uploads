def youtube
	try_connect { firefox.goto "https://www.google.com/accounts/ServiceLogin?uilel=3&service=youtube&passive=true&continue=http%3A%2F%2Fwww.youtube.com%2Fsignin%3Faction_handle_signin%3Dtrue%26nomobiletemp%3D1%26hl%3Den_US%26next%3D%252Findex&hl=en_US&ltmpl=sso" }
	firefox.text_field(:name => 'Email').set(upload.login_for('Youtube.com'))
	firefox.text_field(:name => 'Passwd').set(upload.password_for('Youtube.com'))
	firefox.button(:name => 'signIn').click
	try_login { firefox.link(:href => 'http://upload.youtube.com/my_videos_upload').click }
	firefox.link(:href => 'http://upload.youtube.com/my_videos_upload?restrict=html_form').click
	firefox.button(:id => 'start-upload-button').click
	firefox.file_field.set(upload.mov.path)
	try_until {firefox.text_field(:name => 'title').exists?}
	firefox.text_field(:name => 'title').set(upload.title_rand)
	firefox.text_field(:name => 'description').set(upload.description_rand)
	firefox.text_field(:name => 'keywords').set(upload.keywords_comma_rand)
	firefox.select_list(:name => 'category').select(firefox.select_list(:name => 'category').option(:value => category).text)
	firefox.radio(:name => 'privacy', :value => 'public').set
	firefox.button(:class => 'save-changes-button yt-uix-button').click
	try_while { firefox.span(:class => 'progress-metadata-cancel jslink').visible? }
	sleep 7
	firefox.link(:class => 'end').click
end