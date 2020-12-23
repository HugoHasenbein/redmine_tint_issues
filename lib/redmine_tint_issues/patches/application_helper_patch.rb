# encoding: utf-8
#
# Redmine plugin for having a category tag on attachments
#
# Copyright © 2018 Stephan Wenzel <stephan.wenzel@drwpatent.de>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
#

module RedmineTintIssues
  module Patches 
    module ApplicationHelperPatch
    
      def self.included(base)
        base.class_eval do
        
          # ------------------------------------------------------------------------------#
          # calculates black or white font-color for a given background color
          # ------------------------------------------------------------------------------#
          def rti_contrast_css_color( _html_color )
            return "black" unless _html_color
            begin
              _rgb = _html_color.to_s.downcase.scan(/[0-9a-f]{2}/).map(&:hex)
              (0.213 * _rgb[0] + 0.715 * _rgb[1] + 0.072 * _rgb[2])/255 > 0.5 ? "orange" : "lightyellow"
            rescue
              "black"
            end
          end #def
          
          # ------------------------------------------------------------------------------#
          # lightens color cvalue
          # ------------------------------------------------------------------------------#
          def rti_lighten_css_color(hex_color, amount=0.6)
            return "#ffffff" unless hex_color
            hex_color = hex_color.to_s.gsub('#','')
            rgb = hex_color.scan(/../).map {|color| color.hex}
            rgb[0] = [(rgb[0].to_i + 255 * amount).round, 255].min
            rgb[1] = [(rgb[1].to_i + 255 * amount).round, 255].min
            rgb[2] = [(rgb[2].to_i + 255 * amount).round, 255].min
            "#%02x%02x%02x" % rgb
          end #def
          
        end #base
        
      end #self
      
    end #module
  end #module
end #module

unless ApplicationHelper.included_modules.include?(RedmineTintIssues::Patches::ApplicationHelperPatch)
    ApplicationHelper.send(:include, RedmineTintIssues::Patches::ApplicationHelperPatch)
end


