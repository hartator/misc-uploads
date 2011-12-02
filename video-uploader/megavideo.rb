def megavideo
	try_connect { firefox.goto "http://megavideo.com/?c=login" }
	firefox.text_field(:name => 'username').set(upload.login_for('Megavideo.com'))
	firefox.text_field(:name => 'password').set(upload.password_for('Megavideo.com'))
	firefox.link(:class => 'log_but1').click
	firefox.link(:href => '?c=upload').click
	try_login { firefox.text_field(:name => 'title').set(upload.title_rand) }
	firefox.text_field(:name => 'description').set(upload.description_rand)
	firefox.text_field(:name => 'tags').set(upload.keywords_space_rand)
	firefox.select_list(:name => 'language').select(firefox.select_list(:name => 'language').option(:value => language).text)
	firefox.radio(:name => 'channel', :value => category).set
	firefox.link(:class => 'up_but1').click
	firefox.file_field(:name => 'file').set(upload.mov.path)
	firefox.radio(:name => 'private', :value => '0').set
	try_once { firefox.link(:class => 'up_but3').click }
    try_until { firefox.link(:class => 'bold_lnk2').exists? }
	sleep 7
	try_while{ firefox.link(:class => 'bold_lnk2').text == ''}
	sleep 1
end