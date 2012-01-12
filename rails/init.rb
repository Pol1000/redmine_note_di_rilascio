require 'redmine'

# Redmine 0.8.x patches
module RedmineNoteDiRilascio
  module IssueCompatibilityPatch
    def self.included(base)
      base.class_eval do
        named_scope :visible, lambda {|*args| { :include => :project,
            :conditions => Project.allowed_to_condition(args.first || User.current, :view_issues) } }
      end
    end
  end
end

# Patches to the Redmine core.
require 'dispatcher'

Dispatcher.to_prepare :redmine_nota_di_rilascio do
  require_dependency 'issue'
  Issue.send(:include, RedmineWikiIssueDetails::IssueCompatibilityPatch) unless Issue.respond_to? :visible
end


Redmine::Plugin.register :redmine_note_di_rilascio do
  name 'Redmine Note Di Rilasico'
  author 'Andrea Saccavini'
  url ''
  author_url ''
  description 'Questo plugin aggiunge una wiki macro per agevolare il recupero di informazioni relative ad una segnalazione in una pagina wiki allo scopo di creare note di rilascio.'
  version '0.1.0'
  requires_redmine :version_or_higher => '0.8.0'


  Redmine::WikiFormatting::Macros.register do
    desc "Display an issue and it's details.  Examples:\n\n" +
      "  !{{issue_nota(100,true)}}\n\n"
    macro :issue_nota do |obj, args|
      issue_id = args[0]
      issue_detail = args[1]
      issue = Issue.visible.find_by_id(issue_id)

      return '' unless issue

      if Redmine::AccessControl.permission(:view_estimates) && !User.current.allowed_to?(:view_estimates, issue.project)
        # Check if the view_estimates permission is defined and the user
        # is allowed to view the estimate
        estimates = ''
      elsif issue.estimated_hours && issue.estimated_hours > 0
        estimates = "- #{l_hours(issue.estimated_hours)}"
      else
        estimates = "- <strong>#{l(:redmine_nota_di_rilascio_text_needs_estimate)}</strong>"
      end

      project_link = link_to(h(issue.project), :controller => 'projects', :action => 'show', :id => issue.project)

      returning '' do |response|
        response << '<div>'
	    response << '<span style="color:red;">' if not issue.closed?
	    response << '<span style="color:black; text-decoration:none;">' if issue.closed?
    	response << project_link + ' - ' if not issue.closed?
    	response << link_to_issue(issue) + ' '
		if issue_detail == 'true' then
    	    if not issue.closed?
         		response << estimates + ' ' 
         		response << "(#{h(issue.status)})"
			end 
      
				j = issue.journals.find(:last, !:notes.nil?)
        unless j.nil?
				if !j.notes.nil?
					response << "#{textilizable '> '+j.notes}"
			end
      end
		end
  	  	
        response << '</span></div>'
      end
    end
  end
end
