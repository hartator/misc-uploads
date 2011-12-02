class AdminWebsites

  def self.matches?(request)
    ADMIN_HOSTS.include?(request.host) ? true : false
  end

end

class PreviewWebsites

  def self.matches?(request)
    if PREVIEW_HOSTS.include?(request.host)
      website_to_preview = request.path.split('/')[1]
      return false if website_to_preview.nil?
      cluster = Cluster.where('websites.slug' => website_to_preview.gsub('@','/')).one
      return false if cluster.nil?
      website = cluster.websites.select{|e| e.slug == website_to_preview.gsub('@','/')}.first
      return false if website.nil?
      request.path_parameters[:cluster] = cluster
      request.path_parameters[:website] = website
      request.path_parameters[:prefix] = website_to_preview
      return true
    else
      return false
    end
  end

end

class HostWebsites

  def self.matches?(request)
    return false if PREVIEW_HOSTS.include?(request.host) or ADMIN_HOSTS.include?(request.host)
    cluster = Cluster.where('websites.slug' => request.host).one
    return false if cluster.nil?
    website = cluster.websites.select{|e| e.slug == request.host}.first
    return false if website.nil?
    request.path_parameters[:cluster] = cluster
    request.path_parameters[:website] = website
    request.path_parameters[:prefix] = ''
    return true
  end

end

class PrefixWebsites

  def self.matches?(request)
    return false if PREVIEW_HOSTS.include?(request.host) or ADMIN_HOSTS.include?(request.host)
    unless request.path.split('/').empty?
      host_with_prefix = request.host + '/' + request.path.split('/')[1]
      cluster = Cluster.where('websites.slug' => host_with_prefix).first
      return false if cluster.nil?
      website = cluster.websites.select{|e| e.slug == host_with_prefix}.first
      return false if website.nil?
      request.path_parameters[:cluster] = cluster
      request.path_parameters[:website] = website
      request.path_parameters[:prefix] = request.path.split('/')[1]
      return true
    end
    return false
  end

end
