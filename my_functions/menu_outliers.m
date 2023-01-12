function [action,dataset1,dataset2] = menu_outliers()
%[on apareix la pestanya]
fig = uifigure('Position', [200 200 500 300]);
  
% create a label
label1 = uilabel(fig, 'Position', [20 230, 120 40],'FontSize', 20,'FontWeight', 'bold','Text','ACTION');
label2 = uilabel(fig, 'Position', [20 210, 180 40],'FontSize', 17,'FontWeight', 'bold');

label3 = uilabel(fig, 'Position', [180 230, 120 40],'FontSize', 20,'FontWeight', 'bold','Text','DATA SET 1');
label4 = uilabel(fig, 'Position', [180 210, 120 40],'FontSize', 17,'FontWeight', 'bold');

label5 = uilabel(fig, 'Position', [300 230, 120 40],'FontSize', 20,'FontWeight', 'bold','Text','DATA SET 2');
label6 = uilabel(fig, 'Position', [300 210, 120 40],'FontSize', 17,'FontWeight', 'bold');

% create a dropdownObject and pass the figure as parent
dropdownObject1 = uidropdown(fig,'Items', {'Search OUTLIERS','Compare'},'Value','Search OUTLIERS','Editable', 'on','Position', [20 190 100 20],'ValueChangedFcn', @(dd, event) fruitSelected1(dd, label2));
dropdownObject2 = uidropdown(fig,'Items', {'A_GiG','A_CoG','B_GiG','B_CoG'},'Value','A_GiG','Editable', 'on','Position', [180 190 100 20],'ValueChangedFcn', @(dd, event) fruitSelected2(dd, label4));
dropdownObject3 = uidropdown(fig,'Items', {'A_GiG','A_CoG','B_GiG','B_CoG'},'Value','A_GiG','Editable', 'on','Position', [300 190 100 20],'ValueChangedFcn', @(dd, event) fruitSelected3(dd, label6));

% function to call when option is selected (callback)
function fruitSelected1(dd, label2)
  
% read the value from the dropdown
val = dd.Value;
      
% set the text property of label
label2.Text = val;
action = val;
end
function fruitSelected2(dd, label4)
  
% read the value from the dropdown
val = dd.Value;
      
% set the text property of label
label4.Text = val;
dataset1 = val;
end
function fruitSelected3(dd, label6)
  
% read the value from the dropdown
val = dd.Value;
      
% set the text property of label
label6.Text = val;
dataset2 = val;
end
end

