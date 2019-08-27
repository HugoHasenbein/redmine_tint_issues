# redmine_tint_issues

Plugin for Redmine to tint issues by age and due date

### Use case(s)

* color issues in issue index view by age, start date and due date

### Install

2. download plugin and copy plugin folder redmine_tint_issues to Redmine's plugins folder 

3. restart server f.i.  

`sudo /etc/init.d/apache2 restart`

### Uninstall

1. go to plugins folder, delete plugin folder redmine_tint_issues

`rm -r redmine_tint_issues`

2. restart server f.i. 

`sudo /etc/init.d/apache2 restart`

### Use

* Go to Projects->&lt;your project&gt;->Configuration->Modules and tick 'Tint Issues'
* Go to Administration->Plugins->Redmine Tint Issues and select approriate ages for tickets
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

**1.0.2**
 - simplified module support
 - cleaned code
 
**1.0.1**
 - added module support
 - cleaned code
 
**1.0.0** 
  - running on Redmine 3.4.6 
