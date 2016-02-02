def awetestlib?
  not Awetestlib::Runner.nil?
rescue
  return false
end

And(/^I take a screenshot$/) do
  take_screenshot
end

Before do
  unless awetestlib?
    manifest_file = File.join(File.dirname(__FILE__), '..', 'manifest.json')
    @params = JSON.parse(File.open(manifest_file).read)['params'] #Have access to all params in manifest file
  end
  @text_list = Hash.new()
  @error_file = File.join(File.dirname(__FILE__), '..', '..', 'error.txt')

  if $step_no.to_i < 3
    $step_no = 2
  else
    $step_no = $step_no + 2
  end
  # start_video_recording
end

AfterStep() do
  if @params['capture_all_screenshots']
    take_screenshot
  end
  $step_no = $step_no + 1
  # $step_start_time[$step_no] = Time.now - @video_start_time
end

After do |scenario|
  # end_video_recording
  if scenario.failed?
    if scenario.exception.message.include? "Timeout"
      take_screenshot_timeout
    else
      take_screenshot
    end
    skipped_steps = 0
    scenario.steps.each do |r|
      if r.status.to_s == "skipped"
        skipped_steps +=1
      end
    end
    $step_no += skipped_steps
  else
    $step_no = $step_no - 1
  end
end

def take_screenshot_timeout
  abc = File.expand_path("../..",File.dirname(__FILE__))
  file_na = abc.split("/").last
  file_path = File.join(File.dirname(__FILE__), '..', '..', "#{file_na.to_s}_#{$step_no}.jpg")
  if RUBY_PLATFORM && RUBY_PLATFORM == "java"
    #mac
    system("screencapture -m -S -t jpg #{file_path}")
  else
    #win
    require 'win32/screenshot'
    Win32::Screenshot::Take.of(:desktop).write(file_path)
  end
end

def take_screenshot
  abc = File.expand_path("../..",File.dirname(__FILE__))
  file_na = abc.split("/").last
  file_path = File.join(File.dirname(__FILE__), '..', '..', "#{file_na.to_s}_#{$step_no}.jpg")
  unless @browser.nil?
    @browser.screenshot.save(file_path)
  end
end

def end_video_recording

  $video_recording.write "q"
  $video_recording.close

  #log the time stamps
  abc = File.expand_path("../..",File.dirname(__FILE__))
  file_na = abc.split("/").last
  file_path = File.join(File.dirname(__FILE__), '..', '..', "/awetest_report/#{file_na.to_s}.txt")
  file = File.open(file_path, 'a')
  file.write($step_start_time.to_s)
  file.close
end

def capture_step(elements = [], elements_how_what = {}, texts = [])

end
