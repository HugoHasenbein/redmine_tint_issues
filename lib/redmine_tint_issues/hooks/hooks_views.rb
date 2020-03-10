# encoding: utf-8
#
# Redmine plugin to tint issues by age and due date
#
# Copyright © 2018-2020 Stephan Wenzel <stephan.wenzel@drwpatent.de>
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
  module Hooks
    class CssHooks < Redmine::Hook::ViewListener
      render_on :view_layouts_base_html_head, :partial => 'hooks/redmine_tint_issues/tint_issues_css', :layout => false
    end
  end
end