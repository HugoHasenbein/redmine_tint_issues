# encoding: utf-8
#
# lugin for Redmine to tint issues by age and due date
#
# Copyright © 2019 Stephan Wenzel <stephan.wenzel@drwpatent.de>
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

require 'redmine'

Redmine::Plugin.register :redmine_tint_issues do
  name 'Redmine Tint Issues'
  author 'Stephan Wenzel'
  description 'Plugin for Redmine to tint issues by age and due date'
  version '1.0.2'
  url 'https://github.com/HugoHasenbein/redmine_tint_issues'
  author_url 'https://github.com/HugoHasenbein/redmine_tint_issues'

  project_module :redmine_tint_issues do
    permission :view_issue_tint, {}, {:public => :true}
  end

  settings :default => { 
                       },
           :partial => 'redmine_tint_issues_plugin_settings/settings'
end

require "redmine_tint_issues"

