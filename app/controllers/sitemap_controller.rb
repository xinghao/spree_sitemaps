module Spree
  class SitemapController < Spree::BaseController
    def index
      @public_dir = HOST_PATH + "/"
      @static_nav = _build_static_hash
      respond_to do |format|
        format.xml { @nav=_add_products_to_tax(_build_taxon_hash, false) }
      end
    end
  
    private
    def _build_xml(nav, public_dir)
      tap  do |output|
        xml = Builder::XmlMarkup.new(:target => output, :indent => 2)
        xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
        xml.urlset( :xmlns => "http://www.sitemaps.org/schemas/sitemap/0.9" ) {
          xml.url {
            xml.loc public_dir
            xml.lastmod Date.today
            xml.changefreq 'daily'
            xml.priority '1.0'
          }
          nav.each do |k, v|
            xml.url {
              xml.loc public_dir + v['link']
              xml.lastmod v['updated'].xmlschema #change timestamp of last modified
              xml.changefreq 'daily'
              xml.priority '0.8'
            }
          end
        }
      end
    end
  
    def _build_taxon_hash
      nav = Hash.new
  
      # dont have category now    
      # Taxon.find(:all).each do |taxon|
      #   tinfo = Hash.new
      #   tinfo['name'] = taxon.name
      #   tinfo['depth'] = taxon.permalink.split('/').size
      #   tinfo['link'] = 't/' + taxon.permalink
      #   tinfo['updated'] = taxon.updated_at
      #   nav[taxon.permalink] = tinfo
      # end
      nav
    end
    
    def _build_static_hash
      nav = Hash.new
      nav['about'] = 'about'
      nav['privacy'] = 'privacy'
      nav['help'] = 'help'
      return nav
          
    end
  
    def _add_products_to_tax(nav, multiples_allowed)
      Spree::Product.active.find(:all).each do |product|
        pinfo = Hash.new
        pinfo['name'] = product.name
        pinfo['link'] = 'products/' + product.permalink # primary
        pinfo['updated'] = product.updated_at
  
        nav[pinfo['link']] = pinfo # store primary
        if multiples_allowed
          product.taxons.each do |taxon|
            pinfo['depth'] = taxon.permalink.split('/').size + 1
            taxon_link = taxon.permalink + 'p/' + product.permalink
            new_pinfo = pinfo.clone
            new_pinfo['link'] = taxon_link
            nav[taxon_link] = new_pinfo
          end
        else
        end
      end
      nav
    end
  end
end