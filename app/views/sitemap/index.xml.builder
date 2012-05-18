xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
xml.urlset( :xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9" ) {
  xml.url {
    xml.loc @public_dir
    xml.lastmod Date.today
    xml.changefreq 'daily'
    xml.priority '1.0'
  }
  @nav.each do |k, v|
    xml.url {
      xml.loc @public_dir + v['link']
      xml.lastmod v['updated'].xmlschema 
      xml.changefreq 'weekly'
      xml.priority '0.8'
    }
  end
  
  @static_nav.each do |k, v|
    xml.url {
      xml.loc @public_dir + v
      xml.lastmod Date.today 
      xml.changefreq 'weekly'
      xml.priority '0.7'
    }  
  end
}
