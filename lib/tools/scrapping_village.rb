require 'open-uri'
require 'nokogiri'
require 'net/http'

def get_department_code(num)
  page = Nokogiri::HTML(URI.open("https://www.annuaire-des-mairies.com"))
  @path = "/html/body/div/main/section[2]/div/table/tbody//a[contains(text(), #{num})]"
  page.xpath(@path).text.reverse.chop.chop.chop.chop.chop.reverse.downcase
end

def check_if_page_exists(url)
  url = URI.parse(url)
  req = Net::HTTP.new(url.host, url.port)
  req.use_ssl = true
  res = req.request_head(url.path)

  return res.code === "200"
end

def update_department_list(url)
  page = Nokogiri::HTML(URI.open(url))
  tab = page.xpath('//td[@width="206"]//a[text()]')
  
  errors_array = []

  tab.each do |town|
    town_name = town.text.titleize
    town_name_url = "https://www.annuaire-des-mairies.com#{town['href'].delete_prefix '.'}"

    if check_if_page_exists(town_name_url)
      town_mail = get_townhall_email(town_name_url).gsub(/ /, "")
      town_insee_code = get_townhall_insee_code(town_name_url)
      town_zip_code = get_townhall_zip_code(town_name_url)
      
      if this_village = Village.find_by(name: town_name)
        if town_mail.length > 0
          this_village.update(email: town_mail, zip_code: town_zip_code, insee_code: town_insee_code)
        else
          this_village.update(zip_code: town_zip_code, insee_code: town_insee_code)
        end
        
        puts this_village

        # if !Forum.find_by(title: "Forum principal", village: this_village)
        #     Forum.initialization(this_village)
        # end
      else
        puts town_mail
        if town_mail.length > 0
          this_village = Village.new(name: town_name, email: town_mail, zip_code: town_zip_code, insee_code: town_insee_code)
        else
          this_village = Village.new(name: town_name, zip_code: town_zip_code, insee_code: town_insee_code)
        end

        puts this_village
        puts this_village.valid?

        if this_village.valid?
          this_village.save
          # Forum.initialization(this_village)
        else
          errors_array.push([this_village.name, this_village.email, this_village.zip_code])
        end
      end
    else
      errors_array.push([town_name])
    end
  end

  return errors_array
end

def get_townhall_email(url)
  page = Nokogiri::HTML(URI.open(url))
  result = page.xpath('//section[@class="well section-border"]/div[@class="container"]/table[@class="table table-striped table-mobile mobile-primary round-small"]//tr[@class="txt-primary tr-last"]/td[text()[contains(., "@")]]')

  return result.text.downcase
end

def get_townhall_zip_code(url)
  page = Nokogiri::HTML(URI.open(url))
  result = page.xpath('/html/body/div/main/section[1]/div/div/div/h1')

  return result.text.chars.last(5).join
end

def get_townhall_insee_code(url)
  page = Nokogiri::HTML(URI.open(url))
  result = page.xpath('/html/body/div/main/section[3]/div/table/tbody/tr[1]/td[2]')

  return result.text.chars.last(5).join
end
