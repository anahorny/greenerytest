require 'socket'
require 'rexml/document'
include REXML

class Props

def initialize
  @xmlfile = File.new(File.expand_path("..", File.dirname(__FILE__)) + '/properties.xml')
  @xmldoc = Document.new(@xmlfile)
  @xmlfile_maps = File.new(File.expand_path("..", File.dirname(__FILE__)) + '/mappings.xml')
  @xmldoc_maps = Document.new(@xmlfile_maps)
end

# Method that extracts the environment properties from properties.xml file
#
# USAGE:
# ------------------------Watir code---------------------------------
# $browser.goto $props.get_env("site_url")
# ------------------------Watir code---------------------------------
# ------------------------properties.xml-------------------------------
# <root>
# <host name="common">   
#	<site_url>http://localhost:3000</site_url>
# </host>
# </root>
# ------------------------properties.xml-------------------------------
#
# properties.xml file can have several set of properties - per each host where test suite is running.
# The method automatically identifies the hostname and uses the respective section.
# If it cannot find the respective section, it uses the "common" section.
def get_env(prop_name)
  ret=nil
  known_host=false
  @xmldoc.elements.each("root") {
    |c| c.elements.each("host") {
        |e| if e.attributes["name"] == Socket.gethostname
          e.elements.each() {
          |d| if d.name==prop_name
            ret=d.text
          end
          }
          known_host=true
        end
      }
      if known_host==false
        c.elements.each("host") {
          |e| if e.attributes["name"]=="common"
            e.elements.each() {
            |d| if d.name==prop_name
              ret=d.text
            end
            }
          end
        }
      end
  }
  ret
end

# This is the method that performs given Watir actions with the given object on the given page extracting the object attributes from mappings.xml file.
#
# USAGE:
# ------------------------Watir code---------------------------------
# $props.make('action'=>'set', 'value'=>'pass', 'object'=>'Username field', 'page'=>'Front')
# This will be converted in runtime to the following code:
# 	$browser.text_field(:xpath,"//input[@name='userID']").set("pass")
# ------------------------Watir code---------------------------------
# ------------------------mappings.xml-------------------------------
# <root>
# <page name="Front">
#	<obj name="Username field" type="text_field" attr=":xpath" value="//input[@name='userID']"/>
# </page>
# </root>
# ------------------------mappings.xml-------------------------------
#
# If we have several attributes + object parent elements
# ------------------------Watir code---------------------------------
# $props.make('action'=>'click', 'object'=>'Username field', 'page'=>'Front')
# This will be converted in runtime to the following code:
# 	$browser.frame(:name,"f_7").table(:value,"my").text_field(:xpath,"//input[@name='userID']").click
# ------------------------Watir code---------------------------------
# ------------------------mappings.xml-------------------------------
# <root>
# <page name="Front">
#	<obj name="Username field" type="text_field" attr=":xpath" value="//input[@name='userID']">
#		<parent type="frame" attr=":name" value="f_7"/>
#		<parent type="table" attr=":value" value="my"/>
#	</obj>
# </page>
# </root>
# ------------------------mappings.xml------------------------------- 
#
# If we have several attributes + object parent elements + variable substrings
# ------------------------Watir code---------------------------------
# $props.make({'action'=>'click', 'object'=>'Username field', 'page'=>'Front'}, 25, 50)
# This will be converted in runtime to the following code:
# 	$browser.frame(:name,"f_7").table(:value,"my").text_field(:xpath,"//input[@name='25userID50']").click
# ------------------------Watir code---------------------------------
# ------------------------mappings.xml-------------------------------
# <root>
# <page name="Front">
#	<obj name="Username field" type="text_field" attr=":xpath" value="//input[@name='$var$userID$var$']">
#		<parent type="frame" attr=":name" value="f_7"/>
#		<parent type="table" attr=":value" value="my"/>
#	</obj>
# </page>
# </root>
# ------------------------mappings.xml------------------------------- 
def make(pars, *vars)
  action = pars['action']
  value = pars['value']
  object = pars['object']  
  page = pars['page']  
  exec_str="$browser"
  @xmldoc_maps.elements.each("root") {
    |a| a.elements.each("page") {
        |b| if b.attributes["name"]==page
          b.elements.each("obj") {
            |c| if c.attributes["name"]==object
				c.elements.each("parent") {
					|d| exec_str << "\." << d.attributes["type"] << "\(" << d.attributes["attr"] << "\," << "\"" << d.attributes["value"] << "\"\)"
				}
				attr_value = c.attributes["value"]
				# converting $var1, $var2, ... to the real values passed as optional arguments list
				vars.each { |arg| attr_value.sub!("$var$", arg.to_s) }
				if action.nil?
					return eval exec_str << "\." << c.attributes["type"] << "\(" << c.attributes["attr"] << "\," << "\"" << attr_value << "\"\)"
				end
				if value!=nil
             		exec_str << "\." << c.attributes["type"] << "\(" << c.attributes["attr"] << "\," << "\"" << attr_value << "\"\)" << "\." << action << "\(\"" << value << "\"\)"
				else
					exec_str << "\." << c.attributes["type"] << "\(" << c.attributes["attr"] << "\," << "\"" << attr_value << "\"\)" << "\." << action																
				end
            end
            }
	end
  	}
  }
eval exec_str
end

end

