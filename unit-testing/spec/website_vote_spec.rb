require "game_helper"

  describe "#{website.slug} Valid Up Vote" do
  
    before :each do
      @game = website.games.last
      @game.ratings.where(:website_id => website.id).map &:destroy
      xhr('get', '/' + website.slug.gsub('/','@') + '/' + CGI.escape(@game.category.website(website).slug) + '/' + CGI.escape(@game.website(website).slug) + '/up/')
    end

    it "should return 200" do
      response.status.should be(200)
    end
    
    it "should be long" do
      response.body.size.should > 90
    end
    
    it "should add one voter" do
      @game.voters(website).should be(1)
    end
    
    it "should add one lover" do
      @game.lovers(website).should be(1)
    end
    
    it "should not add one hater" do
      @game.haters(website).should be(0)
    end
    
  end
  
  describe "#{website.slug} 3 Valid Up Vote" do
  
    before :each do
      @game = website.games.last
      @game.ratings.where(:website_id => website.id).map &:destroy
      3.times{ xhr('get', '/' + website.slug.gsub('/','@') + '/' + CGI.escape(@game.category.website(website).slug) + '/' + CGI.escape(@game.website(website).slug) + '/up/') }
    end

    it "should return 200" do
      response.status.should be(200)
    end
    
    it "should be long" do
      response.body.size.should > 90
    end
    
    it "should add one voter" do
      @game.voters(website).should be(1)
    end
    
    it "should add one lover" do
      @game.lovers(website).should be(1)
    end
    
    it "should not add one hater" do
      @game.haters(website).should be(0)
    end
    
  end
  
  describe "#{website.slug} Valid Down Vote" do
  
    before :each do
      @game = website.games.first
      @game.ratings.where(:website_id => website.id).map &:destroy
      xhr('get', '/' + website.slug.gsub('/','@') + '/' + CGI.escape(@game.category.website(website).slug) + '/' + CGI.escape(@game.website(website).slug) + '/down/')
    end

    it "should return 200" do
      response.status.should be(200)
    end
    
    it "should be long" do
      response.body.size.should > 90
    end
    
    it "should add one voter" do
      @game.voters(website).should be(1)
    end
    
    it "should add one lover" do
      @game.lovers(website).should be(0)
    end
    
    it "should not add one hater" do
      @game.haters(website).should be(1)
    end
    
  end 
  
  describe "#{website.slug} 3 Valid Down Vote" do
  
    before :each do
      @game = website.games.first
      @game.ratings.where(:website_id => website.id).map &:destroy
      3.times{ xhr('get', '/' + website.slug.gsub('/','@') + '/' + CGI.escape(@game.category.website(website).slug) + '/' + CGI.escape(@game.website(website).slug) + '/down/') }
    end

    it "should return 200" do
      response.status.should be(200)
    end
    
    it "should be long" do
      response.body.size.should > 90
    end
    
    it "should add one voter" do
      @game.voters(website).should be(1)
    end
    
    it "should add one lover" do
      @game.lovers(website).should be(0)
    end
    
    it "should not add one hater" do
      @game.haters(website).should be(1)
    end
    
  end
  
  describe "#{website.slug} Valid 1 down 1 up Vote" do
  
    before :each do
      @game = website.games.first
      @game.ratings.where(:website_id => website.id).map &:destroy
      xhr('get', '/' + website.slug.gsub('/','@') + '/' + CGI.escape(@game.category.website(website).slug) + '/' + CGI.escape(@game.website(website).slug) + '/down/')
      xhr('get', '/' + website.slug.gsub('/','@') + '/' + CGI.escape(@game.category.website(website).slug) + '/' + CGI.escape(@game.website(website).slug) + '/up/')
    end

    it "should return 200" do
      response.status.should be(200)
    end
    
    it "should be long" do
      response.body.size.should > 90
    end
    
    it "should add one voter" do
      @game.voters(website).should be(1)
    end
    
    it "should add one lover" do
      @game.lovers(website).should be(1)
    end
    
    it "should not add one hater" do
      @game.haters(website).should be(0)
    end
    
  end
  
  describe "#{website.slug} Valid 1 up 1 down Vote" do
  
    before :each do
      @game = website.games.first
      @game.ratings.where(:website_id => website.id).map &:destroy
      xhr('get', '/' + website.slug.gsub('/','@') + '/' + CGI.escape(@game.category.website(website).slug) + '/' + CGI.escape(@game.website(website).slug) + '/up/')
      xhr('get', '/' + website.slug.gsub('/','@') + '/' + CGI.escape(@game.category.website(website).slug) + '/' + CGI.escape(@game.website(website).slug) + '/down/')
    end

    it "should return 200" do
      response.status.should be(200)
    end
    
    it "should be long" do
      response.body.size.should > 90
    end
    
    it "should add one voter" do
      @game.voters(website).should be(1)
    end
    
    it "should add one lover" do
      @game.lovers(website).should be(0)
    end
    
    it "should not add one hater" do
      @game.haters(website).should be(1)
    end
    
  end
  
  describe "#{website.slug} Invalid Vote" do
    
    before :each do
      @game = website.games.last
    end
       
    it "should return 404" do
      expect { get '/' + website.slug.gsub('/','@') + '/' + CGI.escape(@game.category.website(website).slug) + '/' + CGI.escape(@game.website(website).slug) + '/up/down/'}.to raise_error(ActionController::RoutingError)
    end
    
    it "should return 404" do
      expect { get '/' + website.slug.gsub('/','@') + '/' + CGI.escape(@game.category.website(website).slug) + '/' + CGI.escape(@game.website(website).slug) + '/up/ddff/'}.to raise_error(ActionController::RoutingError)
    end
    
  end
  
  describe "#{website.slug} Valid Game/vote Invalid Category" do
    
    before :each do
      @game = website.games.last
    end

    it "should return 404" do
      expect { get '/' + website.slug.gsub('/','@') + '/' + CGI.escape(@game.category.website(website).slug) + 'ddff' + '/' + CGI.escape(@game.website(website).slug) + '/up/'
        }.to raise_error(ActionController::RoutingError)
    end
    
    it "should return 404" do
      expect { get '/' + website.slug.gsub('/','@') + '/' + CGI.escape(@game.category.website(website).slug) + 'ddff' + '/' + CGI.escape(@game.website(website).slug) + '/down/'
        }.to raise_error(ActionController::RoutingError)
    end
    
  end
  
  describe "#{website.slug} Redirect Vote" do
    
    before :each do
      @game = website.games.last
    end

    it "should return 301" do
      get '/' + website.slug.gsub('/','@') + '/' + CGI.escape(@game.category.website(website).slug) + '/' + CGI.escape(@game.website(website).slug) + '/up'
      response.status.should be(301)
    end
    
    it "should return 301" do
      get '/' + website.slug.gsub('/','@') + '/' + CGI.escape(@game.category.website(website).slug) + '/' + CGI.escape(@game.website(website).slug) + '/down'
      response.status.should be(301)
    end
    
    it "should return 301" do
      get '/' + website.slug.gsub('/','@') + '/' + CGI.escape(@game.category.website(website).slug) + '/' + CGI.escape(@game.website(website).slug) + '/up/'
      response.status.should be(301)
    end
    
    it "should return 301" do
      get '/' + website.slug.gsub('/','@') + '/' + CGI.escape(@game.category.website(website).slug) + '/' + CGI.escape(@game.website(website).slug) + '/down/'
      response.status.should be(301)
    end
    
    it "should return 301" do
      get '/' + website.slug.gsub('/','@') + '/' + CGI.escape(@game.category.website(website).slug) + '/' + CGI.escape(@game.website(website).slug) + '/ddff'
      response.status.should be(301)
    end
    
    it "should return 301" do
      get '/' + website.slug.gsub('/','@') + '/' + CGI.escape(@game.category.website(website).slug) + '/' + CGI.escape(@game.website(website).slug) + '/ddff.html/'
      response.status.should be(301)
    end
    
  end
  
  describe "#{website.slug} Index after Vote" do
  
    before :each do
      get '/' + website.slug.gsub('/','@')
    end

    it "should loads the index template" do
      response.should render_template(:index)
    end

    it "should return 200" do
      response.status.should be(200)
    end
    
    it "should be long" do
      response.body.size.should > 250
    end

  end

end