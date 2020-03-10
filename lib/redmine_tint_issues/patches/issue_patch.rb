# encoding: utf-8
#
# lugin for Redmine to tint issues by age and due date
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
    module IssuePatch
    
      def self.included(base)
        base.send(:include, InstanceMethods)
        
        base.class_eval do

          alias_method :css_classes_without_tint_issues, :css_classes
          alias_method :css_classes, :css_classes_with_tint_issues

        end
      end #self
      
      module InstanceMethods
      
        def css_classes_with_tint_issues(user=User.current)
          s = css_classes_without_tint_issues(user)
          if self.project.module_enabled?(:redmine_tint_issues)
            s << self.issue_age.to_s
            s << self.issue_due.to_s
          end
          s
        end #def
        
##########################################################################################
# handle age
##########################################################################################
        def issue_age
          return is_current
        end #defined
        
        def is_current
          if !!dues_and_ages(:current_issue_age)
            start   = to_time(self.start_date).presence || self.created_on
            younger = start > dues_and_ages(:current_issue_age)
            return younger ? ' current' : is_old
          end
          return is_old
        end #def
        
        def is_old
          if !!dues_and_ages(:old_issue_age)
            start   = to_time(self.start_date).presence || self.created_on
            younger = start > dues_and_ages(:old_issue_age)
            return younger ? ' old' : is_older 
          end
          return is_older 
        end #def
        
        def is_older
          if !!dues_and_ages(:older_issue_age)
            start   = to_time(self.start_date).presence || self.created_on
            younger = start > dues_and_ages(:older_issue_age)
            return younger ? ' older' : is_veryold
          end
          return is_veryold
        end #def
        
        def is_veryold
          if !!dues_and_ages(:veryold_issue_age)
            start   = to_time(self.start_date).presence || self.created_on
            younger = start > dues_and_ages(:veryold_issue_age)
            return younger ? ' veryold' : ' ancient'
          end
          return %i(
            current_issue_age 
            old_issue_age 
            older_issue_age 
            veryold_issue_age
          ).any?{|age| !!dues_and_ages(age)} ? " ancient" : ""
        end #def
        
##########################################################################################
# handle due date
##########################################################################################
        
        def issue_due
            return is_overdue if self.due_date && !self.closed?
            return ''
        end #defined
        
        def is_overdue
          return overdue? ? ' overdue' : is_verydue
        end #def
        
        def is_verydue
          if !!dues_and_ages(:verydue_since)
            farer = self.due_date > dues_and_ages(:verydue_since)
            return farer ? is_moredue : ' verydue'
          end #if
          return is_due
        end #def
        
        def is_moredue
          if !!dues_and_ages(:moredue_since)
            farer = self.due_date > dues_and_ages(:moredue_since)
            return farer ? is_due : ' moredue'
          end #if
          return is_due
        end #def

        def is_due
          if !!dues_and_ages(:due_since)
            farer = self.due_date > dues_and_ages(:due_since)
            return farer ? ' hasduedate' : ' due'
          end #if
          return %i(
            due_since 
            moredue_since 
            verydue_since 
          ).any?{|since| !!dues_and_ages(since)} ? " hasduedate" : ""
        end #def
        
##########################################################################################
# calculate time and time differences
##########################################################################################
        
        def to_time( timestr )
          timestr.presence && timestr.to_time
        end #def
      
        def getpastdate( num, epoch )
          if num.present?
            case epoch
              when "hours"
                  num.to_i.hours.ago
              when "days"
                  num.to_i.days.ago
              when "weeks"
                  num.to_i.weeks.ago
              when "months"
                  num.to_i.months.ago
            end #case
          end #if
        end #def
        
        def getfuturedate( num, epoch )
          if num.present?
            case epoch
              when "hours"
                  num.to_i.hours.since.to_date
              when "days"
                  num.to_i.days.since.to_date
              when "weeks"
                  num.to_i.weeks.since.to_date
              when "months"
                  num.to_i.months.since.to_date
            end #case
          end #if
        end #def
        
##########################################################################################
# calculate once and cache date calculations
##########################################################################################
        
        def dues_and_ages( key )
        
           if defined?(@@dues_and_ages) && @@dues_and_ages.present?             
             if Setting["plugin_redmine_tint_issues"]["ages_calculated"]
               return @@dues_and_ages[key]
             end #if
           end #if
          @@dues_and_ages = {}
          
          @@dues_and_ages.merge!( :due_since => getfuturedate(
              Setting["plugin_redmine_tint_issues"]["due_since"], 
              Setting["plugin_redmine_tint_issues"]["due_since_epoch"]
            )
          )
          
          @@dues_and_ages.merge!( :moredue_since => getfuturedate(
              Setting["plugin_redmine_tint_issues"]["moredue_since"], 
              Setting["plugin_redmine_tint_issues"]["moredue_since_epoch"]
            )
          )
          
          @@dues_and_ages.merge!( :verydue_since => getfuturedate(
              Setting["plugin_redmine_tint_issues"]["verydue_since"], 
              Setting["plugin_redmine_tint_issues"]["verydue_since_epoch"]
            )
          )
          
          @@dues_and_ages.merge!( :current_issue_age => getpastdate(
              Setting["plugin_redmine_tint_issues"]["current_issue_age"], 
              Setting["plugin_redmine_tint_issues"]["current_issue_age_epoch"]
            )
          )
          
          @@dues_and_ages.merge!( :old_issue_age => getpastdate(
              Setting["plugin_redmine_tint_issues"]["old_issue_age"], 
              Setting["plugin_redmine_tint_issues"]["old_issue_age_epoch"]
            )
          )
        
          @@dues_and_ages.merge!( :older_issue_age => getpastdate(
              Setting["plugin_redmine_tint_issues"]["older_issue_age"], 
              Setting["plugin_redmine_tint_issues"]["older_issue_age_epoch"]
            )
          )
          
          @@dues_and_ages.merge!( :veryold_issue_age => getpastdate(
              Setting["plugin_redmine_tint_issues"]["veryold_issue_age"], 
              Setting["plugin_redmine_tint_issues"]["veryold_issue_age_epoch"]
            )
          )
          
          @@dues_and_ages.compact!
          ###########################################################
          # the following will not be saved and will cease to exist #
          # after settings update and/or rails restart              #
          ###########################################################
          Setting["plugin_redmine_tint_issues"]["ages_calculated"] = DateTime.now
          @@dues_and_ages[key]
        end #def
        
      end #module
    end #module
  end #module
end #module

unless Issue.included_modules.include?(RedmineTintIssues::Patches::IssuePatch)
    Issue.send(:include, RedmineTintIssues::Patches::IssuePatch)
end
