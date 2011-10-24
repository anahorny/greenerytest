# This is the method to wait until elements on AJAX pages are completely loaded to avoid usage of fixed time intervals.
# Examples of method usage:
# rescue_wait_retry { @browser.frame(:name, "f_7").text_field(:xpath, "//input[@name='userID']").set(username) }
# rescue_wait_retry { @browser.frame(:name, "f_0").text.include?(text).should == true }
def wait(times = 10, seconds = 2, &block)
  begin
    return yield
  rescue
    sleep(seconds)
    $browser.wait
    if (times -= 1)> 0      
      retry
    end
  end
  yield
end

