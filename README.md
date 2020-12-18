# redmine_tint_issues

Plugin for Redmine to tint issues by age and due date

### Use case(s)

* color issues in issue index view by age, start date and due date

![PNG that represents a quick overview](/doc/issue_index.png)

### Install

1. download plugin and copy plugin folder redmine_tint_issues to Redmine's plugins folder 

2. restart server f.i.  

`sudo /etc/init.d/apache2 restart`

(no migration is necessary)

### Uninstall

1. go to plugins folder, delete plugin folder redmine_tint_issues

`rm -r redmine_tint_issues`

2. restart server f.i. 

`sudo /etc/init.d/apache2 restart`

### Use

* Go to Projects->&lt;your project&gt;->Settings->Modules and tick 'Tint Issues'
* Go to Administration->Plugins->Redmine Tint Issues and select approriate ages for tickets

![PNG that represents a quick overview](/doc/plugin_configuration.png)

note: you may leave input fields empty, f.i. if you just want two colors, one for 'old' and one for 'very old'

* On issue index page you will see issue rows colored by age having left and side colored bars
  
### How is the color determined?

Redmine Tint Issues looks for an issue start date. If it cannot find a start date, because it is empty, then it uses the issue creation date. Redmine Tint Issues wil calculate the age based on today minus the aforementioned dates and color the issue row accordingly. 

If the issue has a due date, then Redmine Tint Issues will put a grey, green, orange or red bar on the left and right side of the issue row. If the issue is overdue, the issue will be marked with two black bars.

The style can easily be changed by amending the style sheet in the assets/styleshets folder. Do not edit the styleshet in the public/plugin_assets folder as it will be overridden each time redmine is rebootet.

**Have fun!**

### Localisations

* 1.0.2
  - English
  - German

### Change-Log* 

**1.2.0**
 - support individual color selection for each color code in plugin setup
 - choose to base issue age on creation date or on last update date

**1.1.0**
 - support for Rails >= 5.0
 
**1.0.2**
 - simplified module support
 - cleaned code
 
**1.0.1**
 - added module support
 - cleaned code
 
**1.0.0** 
  - running on Redmine 3.4.6, 3.4.11
