
Then(/^I read the data from the spreadsheet$/) do
  require 'spreadsheet'
  Spreadsheet.client_encoding = 'UTF-8'
  @myRoot = File.join(File.dirname(__FILE__),'/')
  book = Spreadsheet.open "#{@myRoot}data.xls"
  # book = Spreadsheet.open 'excel-file.xls'
  book.worksheets
  obj_repo = book.worksheet 'obj_repo'
  user_data = book.worksheet 'user_data'
  login = book.worksheet 'login'

  @login_row = {}
  login.each do |row|
      @login_row[row[0]] = row[1..3]
  end
  @obj_repo_row = {}
  obj_repo.each do |row|
      @obj_repo_row[row[0]] = row[1..5]
  end
  @user_data_row = {}
  user_data.each do |row|
      @user_data_row[row[0]] = row[1]
  end
end


########## This is for xlsx format spreadsheet
# Then(/^I read the data from the spreadsheet$/) do
  # require 'roo'
  # require 'spreadsheet'
  #@myRoot = File.join(File.dirname(__FILE__),'/')
  # book = Roo::Spreadsheet.open "#{@myRoot}data.xls"
  
  # def read_data(sheet_name)
  # data = {}
  # for i in 1..sheet_name.last_row
  # data[sheet_name.row(i)[0]] = sheet_name.row(i)[1..sheet_name.last_column]
  # end
  # return data
  # end
  
  # obj_repo = book.sheet("obj_repo")
  # @obj_repo_row = read_data(obj_repo)
  # user_data = book.sheet("user_data")
  # @user_data_row = read_data(user_data)
  # login = book.sheet("login")
  # @login_row = read_data(login)
  

def find_el(el_name)
  obj_info=@obj_repo_row["#{el_name}"]
  parent = @browser
  if obj_info[4]
    find_els(el_name)[obj_info[4].to_i]
  else
    if obj_info[3]
      frame =@obj_repo_row["#{obj_info[3]}"]
      if frame[2] == 'iframe'
        parent =  @browser.iframe(frame[0].to_sym, "#{frame[1]}")
      elsif  frame[2] == 'form'
        parent = @browser.form(frame[0].to_sym, "#{frame[1]}")
      end
    end

    if (obj_info[2] == "link")
      parent.link(obj_info[0].to_sym, "#{obj_info[1]}")
    elsif (obj_info[2] == "button")
      parent.button(obj_info[0].to_sym, "#{obj_info[1]}")
    elsif (obj_info[2] == "image")
      parent.image(obj_info[0].to_sym, "#{obj_info[1]}")
    elsif (obj_info[2] == "span")
      parent.span(obj_info[0].to_sym, "#{obj_info[1]}")
    else
      parent.element(obj_info[0].to_sym, "#{obj_info[1]}")
    end
  end
end

def find_els(el_name)
  obj_info=@obj_repo_row["#{el_name}"]
  parent = @browser
  if obj_info[3]
    frame =@obj_repo_row["#{obj_info[3]}"]
    if frame[2] == 'iframe'
      parent =  @browser.frame(frame[0].to_sym, "#{frame[1]}")
    elsif  frame[2] == 'form'
      parent = @browser.form(frame[0].to_sym, "#{frame[1]}")
    end
  end

  if (obj_info[2] == "link")
    parent.links(obj_info[0].to_sym, "#{obj_info[1]}")
  elsif (obj_info[2] == "button")
    parent.buttons(obj_info[0].to_sym, "#{obj_info[1]}")
  elsif (obj_info[2] == "name")
    parent.names(obj_info[0].to_sym, "#{obj_info[1]}")
  elsif (obj_info[2] == "image")
    parent.images(obj_info[0].to_sym, "#{obj_info[1]}")
  elsif (obj_info[2] == "span")
    parent.spans(obj_info[0].to_sym, "#{obj_info[1]}")
  else
    parent.elements(obj_info[0].to_sym, "#{obj_info[1]}")
  end
end

def find_element(element_name, how=nil, what=nil,element=nil,parent=nil)
  how ||= @obj_repo_row[element_name][0]
  what ||= @obj_repo_row[element_name][1]
  element ||= @obj_repo_row[element_name][2]
  parent ||= @obj_repo_row[element_name][3]
  get_element(element, how, what, parent)
end

#get all the parents of object to find the element to final object.
#used by getelement function if you have frames within frames
def get_parent(browser, element)
  frame =@obj_repo_row["#{element}"]
  if frame[3]
    browser = get_parent(browser,frame[3])
  end
  
 if frame[2] == 'iframe'
    parent =  browser.iframe(frame[0].to_sym, "#{frame[1]}")
  elsif  frame[2] == 'form'
    parent = browser.form(frame[0].to_sym, "#{frame[1]}")
  else
    parent = browser.element(frame[0].to_sym, "#{frame[1]}")
  end
  parent
  end


def wait_until_ready(el)
  Watir::Wait.until {el.exists?} rescue nil
  Watir::Wait.until {el.visible?}rescue nil
  Watir::Wait.until {el.enabled?}rescue nil
  el
end

def get_value(value)
  value = @user_data_row[value] if @user_data_row[value]
  value
end

def get_element(element, how, what, parent_el = nil)
  parent = @browser
  if parent_el
    parent = get_parent(@browser, parent_el)
  end
  target = nil
  
 
  what = Regexp.new(Regexp.escape(what)) if how == 'regex' #or what.is_a?(Regexp)
  how = 'text' if how == 'regex'
  how = how.to_sym rescue nil
  case (element.to_sym rescue nil)
    when :link, :a
      target = parent.a(how, what)
    when :button
      target = parent.button(how, what)
    when :div
      target = parent.div(how, what)
    when :checkbox
      target = parent.checkbox(how, what)
    when :text_field, :textfield
	   target = parent.text_field(how, what)
    when :image
      target = parent.image(how, what)
    when :file_field, :filefield
      target = parent.file_field(how, what)
    when :form
      target = parent.form(how, what)
    when :frame
      target = parent.iframe(how, what)
    when :radio
      target = parent.radio(how, what)
    when :span
      target = parent.span(how, what)
    when :table
      target = parent.table(how, what)
    when :li
      target = parent.li(how, what)
    when :select_list, :selectlist, :dropdown
      target = parent.select_list(how, what)
    when :hidden
      target = parent.hidden(how, what)
    when :area
      target = parent.area(how, what)
    when :header
      target = parent.headers[0]
    when :h1
      target = parent.h1(how, what)
    when :h2
      target = parent.h2(how, what)
    when :h3
      target = parent.h3(how, what)
    when :h4
      target = parent.h4(how, what)
    else
      target = parent.element(how, what)
  end
  target
end

Then(/^I read the data from the stylesheet$/) do
  require 'spreadsheet'
  Spreadsheet.client_encoding = 'UTF-8'
  @myRoot = File.join(File.dirname(__FILE__),'/')
  book = Spreadsheet.open "#{@myRoot}CEOMobile_Branding.xls"
  book.worksheets
  obj_repo = book.worksheet 'obj_repo'
  @obj_repo_row = {}
  obj_repo.each do |row|
    row.each do |x|
      #row[3] is a state
      #row[4] is a first property
      #row[5] is the first value
      @obj_repo_row[row[0]] = row[1..45]
    end
  end
  sleep(1)
end

## show the errors
And(/^show errors if any$/) do
  @fail_log ||= []
  @fail_log.empty? ? puts('All passed') : raise(@fail_log.join(" "))
end


And(/^I click the "([^"]*)"$/) do |element_name|
  Watir::Wait.until {
    el = find_element(element_name)
    el.present?
    el.focus
    el.click}
end

And(/^I click the "([^"]*)" if on "([^"]*)" page$/) do |element_name, title|
  sleep 2
  if @browser.window.title.include? title
    Watir::Wait.until {
      el = find_element(element_name)
      # el.present?
      # el.focus
      el.click
	  }
  end
end

## Click button or link
## Example: * click "Submit"
And(/^click "([^"]*)"$/) do |arg|
  wait_until_ready(find_element(arg)).click
end

## Select value from dropdown
And(/^select "([^"]*)" from "([^"]*)"$/) do |value, dropdown|
  sleep 5
  find_element(dropdown).when_present.select get_value(value)

end

## Checkbox and Radio button selection
## Example: * select "Keep me signed in"
And(/^select "([^"]*)"$/) do |element|
 sleep 5
  find_element(element).when_present.set
end

## Checkbox and Radio button clear selection
## Example: * unselect "Keep me signed in"
And(/^unselect "([^"]*)"$/) do |element|
 sleep 5
  find_element(element).when_present.clear
end

## Enter values in the text field
## Example: * enter "email" into "Email Address"
And(/^enter "([^"]*)" into "([^"]*)"$/) do |text, input_field|
  wait_until_ready(find_element(input_field).when_present).send_keys(get_value(text))
end

## Check text of the element
## Example: * "text_SignIn" is displayed in "SignInbutton"
And(/^"([^"]*)" is displayed in "([^"]*)"$/) do |text, element|
  text=get_value(text)
  what = @obj_repo_row[element][1]
  if what
    el = find_element(element)
    raise("Value does not match: \n Expected: #{text} \n Actual: #{el.text}") unless el.text == text
  else
   el = find_element(element,"text",text).when_present
  end
  raise("element not visible") unless el.visible?
  el.flash
end