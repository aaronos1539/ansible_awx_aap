## Hide PowerShell Console
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr, 0)



## Setting Variables
$New_Drive_Var = 'sdc'
$vg_label_Var = 'vg_'
$lv_Label_Var = 'lv_'
$Mount_Point_Path_Var = ''
$Command_Output = ''

function Run-Form {
  # Builds the form
  Add-Type -AssemblyName System.Windows.Forms
  Add-Type -AssemblyName System.Drawing

  $form = New-Object Windows.Forms.Form -Property @{
      StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
      #Size          = New-Object Drawing.Size 900, 475
      Size          = New-Object Drawing.Size 900, 625
      Text          = 'LVM - Modify Drives'
      Topmost       = $true
  }
  ########################################################################
  ########################################################################
  $LVM_Extensions_Type_ListBox_Label = New-Object System.Windows.Forms.Label -Property @{
      Location     = New-Object Drawing.Point 10, 20
      Size         = New-Object System.Drawing.Size(350,20)
      Text         = "Pick how the partion is being extended:"
  }
  $form.Controls.Add($LVM_Extensions_Type_ListBox_Label)
  
  $LVM_Extensions_Type_ListBox = New-Object System.Windows.Forms.ListBox -Property @{
      Location     = New-Object Drawing.Point 10, 40
      Size         = New-Object System.Drawing.Size(350,50)
  }

  $LVM_Extensions_Type_ListBox.Items.Add("Adding a new Drive and new Partition")
  $LVM_Extensions_Type_ListBox.Items.Add("Extend Partion with New Drive")
  $LVM_Extensions_Type_ListBox.Items.Add("Extend Partion by Extending Current Physical Drive")
  $form.Controls.Add($LVM_Extensions_Type_ListBox)
  ########################################################################
  ########################################################################
  $New_Drive_Label = New-Object System.Windows.Forms.Label -Property @{
      Location     = New-Object Drawing.Point 10, 120
      Size         = New-Object System.Drawing.Size(350,20)
      Text         = 'Enter New Drive. Example "sdc"'
  }
  #$form.Controls.Add($New_Drive_Label)

  $New_Drive_TextBox = New-Object System.Windows.Forms.TextBox -Property @{
      Location     = New-Object Drawing.Point 10, 140
      Size         = New-Object System.Drawing.Size(350,20)
      Text         = $New_Drive_Var
  }
  #$form.Controls.Add($New_Drive_TextBox)
  ########################################################################
  ########################################################################
  $Old_Drive_Label = New-Object System.Windows.Forms.Label -Property @{
      Location     = New-Object Drawing.Point 10, 120
      Size         = New-Object System.Drawing.Size(350,20)
      Text         = 'Enter the Drive that was just enlarged in vCenter. Example "sda"'
  }
  #$form.Controls.Add($New_Drive_Label)

  $Old_Drive_TextBox = New-Object System.Windows.Forms.TextBox -Property @{
      Location     = New-Object Drawing.Point 10, 140
      Size         = New-Object System.Drawing.Size(350,20)
      Text         = "sda"
  }
  #$form.Controls.Add($New_Drive_TextBox)
  ########################################################################
  ########################################################################
  $vg_Label_Label = New-Object System.Windows.Forms.Label -Property @{
      Location     = New-Object Drawing.Point 10, 170
      Size         = New-Object System.Drawing.Size(350,20)
      Text         = 'Enter Volume Group Name. Example "vg_test"'
  }
  #$form.Controls.Add($vg_Label_Label)

  $vg_Label_TextBox = New-Object System.Windows.Forms.TextBox -Property @{
      Location     = New-Object Drawing.Point 10, 190
      Size         = New-Object System.Drawing.Size(350,20)
      Text         = $vg_label_Var
  }
  #$form.Controls.Add($vg_Label_TextBox)
  ########################################################################
  ########################################################################
  $lv_Label_Label = New-Object System.Windows.Forms.Label -Property @{
      Location     = New-Object Drawing.Point 10, 220
      Size         = New-Object System.Drawing.Size(350,20)
      Text         = 'Enter Logical Volume Name. Example "lv_test"'
  }
  #$form.Controls.Add($lv_Label_Label)

  $lv_Label_TextBox = New-Object System.Windows.Forms.TextBox -Property @{
      Location     = New-Object Drawing.Point 10, 240
      Size         = New-Object System.Drawing.Size(350,20)
      Text         = $lv_Label_Var
  }
  #$form.Controls.Add($lv_Label_TextBox)
  ########################################################################
  ########################################################################
  $Mount_Point_Path_Label = New-Object System.Windows.Forms.Label -Property @{
      Location     = New-Object Drawing.Point 10, 270
      Size         = New-Object System.Drawing.Size(350,20)
      Text         = 'Enter Mount Point Path. Example "/opt/test"'
  }
  #$form.Controls.Add($Mount_Point_Path_Label)

  $Mount_Point_Path_TextBox = New-Object System.Windows.Forms.TextBox -Property @{
      Location     = New-Object Drawing.Point 10, 290
      Size         = New-Object System.Drawing.Size(350,20)
      Text         = $Mount_Point_Path_Var
  }
  #$form.Controls.Add($Mount_Point_Path_TextBox)
  ########################################################################
  ########################################################################
  $New_Drive_Partition_Number_Label = New-Object System.Windows.Forms.Label -Property @{
      Location     = New-Object Drawing.Point 10, 270
      Size         = New-Object System.Drawing.Size(350,20)
      Text         = 'Enter New Partition Number. Example "1"'
  }
  #$form.Controls.Add($Mount_Point_Path_Label)

  $New_Drive_Partition_Number_TextBox = New-Object System.Windows.Forms.TextBox -Property @{
      Location     = New-Object Drawing.Point 10, 290
      Size         = New-Object System.Drawing.Size(350,20)
      Text         = '1'
  }
  #$form.Controls.Add($Mount_Point_Path_TextBox)
  ########################################################################
  ########################################################################
  $Old_Drive_Partition_Number_Label = New-Object System.Windows.Forms.Label -Property @{
      Location     = New-Object Drawing.Point 10, 270
      Size         = New-Object System.Drawing.Size(400,20)
      Text         = 'Enter the Last Partition Number of drive that was just enlarged. Example "2"'
  }
  #$form.Controls.Add($Mount_Point_Path_Label)

  $Old_Drive_Partition_Number_TextBox = New-Object System.Windows.Forms.TextBox -Property @{
      Location     = New-Object Drawing.Point 10, 290
      Size         = New-Object System.Drawing.Size(350,20)
      Text         = '2'
  }
  #$form.Controls.Add($Mount_Point_Path_TextBox)
  ########################################################################
  ########################################################################
  $Hint_Label = New-Object System.Windows.Forms.Label -Property @{
      Location     = New-Object Drawing.Point 450, 200
      Size         = New-Object System.Drawing.Size(350,40)
      Text         = 'Hint:  Use the comand "sudo lsblk" to get the Volume Group, Logical Volume and Partion numbers'
  }
  $form.Controls.Add($Hint_Label)
  ########################################################################
  ########################################################################
  $Command_Output_Label = New-Object System.Windows.Forms.Label -Property @{
      Location     = New-Object Drawing.Point 10, 320
      Size         = New-Object System.Drawing.Size(350,20)
      Text         = 'Command Output:'
  }
  $form.Controls.Add($Command_Output_Label)

  $Command_Output_TextBox = New-Object System.Windows.Forms.TextBox -Property @{
      Multiline    = $True;
      Scrollbars   = "Vertical"
      Location     = New-Object Drawing.Point 10, 340
      Size         = New-Object System.Drawing.Size(870,200)
      Text         = $Command_Output
  }
  $form.Controls.Add($Command_Output_TextBox)
  ########################################################################
  ########################################################################
  ## Add Select ListBox click event
  $LVM_Extensions_Type_ListBox.Add_Click(
  {
      $form.Controls.Remove($New_Drive_Label)
      $form.Controls.Remove($New_Drive_TextBox)
      $form.Controls.Remove($Old_Drive_Label)
      $form.Controls.Remove($Old_Drive_TextBox)
      $form.Controls.Remove($vg_Label_Label)
      $form.Controls.Remove($vg_Label_TextBox)
      $form.Controls.Remove($lv_Label_Label)
      $form.Controls.Remove($lv_Label_TextBox)
      $form.Controls.Remove($Mount_Point_Path_Label)
      $form.Controls.Remove($Mount_Point_Path_TextBox)
      $form.Controls.Remove($New_Drive_Partition_Number_Label)
      $form.Controls.Remove($New_Drive_Partition_Number_TextBox)
      $form.Controls.Remove($Old_Drive_Partition_Number_Label)
      $form.Controls.Remove($Old_Drive_Partition_Number_TextBox)
      $Command_Output_TextBox.Text = ""
      $LVM_Extensions_Type_ListBox_Selection = $LVM_Extensions_Type_ListBox.SelectedItem.ToString()
      switch ($LVM_Extensions_Type_ListBox_Selection)
      {
          "Adding a new Drive and new Partition" {$form.Controls.Add($New_Drive_Label)
                                                  $form.Controls.Add($New_Drive_TextBox)
                                                  $form.Controls.Add($vg_Label_Label)
                                                  $form.Controls.Add($vg_Label_TextBox)
                                                  $form.Controls.Add($lv_Label_Label)
                                                  $form.Controls.Add($lv_Label_TextBox)
                                                  $form.Controls.Add($Mount_Point_Path_Label)
                                                  $form.Controls.Add($Mount_Point_Path_TextBox)}
          "Extend Partion with New Drive"        {$form.Controls.Add($New_Drive_Label)
                                                  $form.Controls.Add($New_Drive_TextBox)
                                                  $form.Controls.Add($vg_Label_Label)
                                                  $form.Controls.Add($vg_Label_TextBox)
                                                  $form.Controls.Add($lv_Label_Label)
                                                  $form.Controls.Add($lv_Label_TextBox)
                                                  $form.Controls.Add($New_Drive_Partition_Number_Label)
                                                  $form.Controls.Add($New_Drive_Partition_Number_TextBox)}
          "Extend Partion by Extending Current Physical Drive" {$form.Controls.Add($Old_Drive_Label)
                                                  $form.Controls.Add($Old_Drive_TextBox)
                                                  $form.Controls.Add($vg_Label_Label)
                                                  $form.Controls.Add($vg_Label_TextBox)
                                                  $form.Controls.Add($lv_Label_Label)
                                                  $form.Controls.Add($lv_Label_TextBox)
                                                  $form.Controls.Add($Old_Drive_Partition_Number_Label)
                                                  $form.Controls.Add($Old_Drive_Partition_Number_TextBox)}
          Default {$Command_Output_TextBox.Text = "Please Select Type"}
      }
  }
  )
  ########################################################################
  ########################################################################
  ## Add Run Button
  $RunFormButton = New-Object Windows.Forms.Button -Property @{
      Location     = New-Object Drawing.Point 350, 550
      Size         = New-Object Drawing.Size 75, 23
      Text         = 'Run'
  }
  $form.Controls.Add($RunFormButton)
  
  
  ## Add Run Button event
  $RunFormButton.Add_Click(
  {
      try { 
          $LVM_Extensions_Type_ListBox_Selection = $LVM_Extensions_Type_ListBox.SelectedItem.ToString()
      }
      catch {$Command_Output_TextBox.Text = "Please Select Type"}
      switch ($LVM_Extensions_Type_ListBox_Selection)
      {
          "Adding a new Drive and new Partition"               {$New_Drive_Var = $New_Drive_TextBox.Text
                                                                $vg_label_Var = $vg_Label_TextBox.Text
                                                                $lv_Label_Var = $lv_Label_TextBox.Text
                                                                $Mount_Point_Path_Var = $Mount_Point_Path_TextBox.Text
                                                                $Command_Output_TextBox.Text = "Loading..."
                                                                $Command_Output_TextBox.Text = "echo `"- - -`" | sudo tee /sys/class/scsi_host/host*/scan" + "`r`n" +`
                                                                                               "sudo parted --script /dev/" + $New_Drive_TextBox.Text + " mklabel gpt mkpart primary '0%' '100%'" + "`r`n" +`
                                                                                               "sudo pvcreate /dev/" + $New_Drive_TextBox.Text+ "1" + "`r`n"` +`
                                                                                               "sudo vgcreate " + $vg_label_Var + " /dev/" + $New_Drive_TextBox.Text + "1" + "`r`n"` +`
                                                                                               "sudo lvcreate -l 100%VG -n " + $lv_Label_TextBox.Text + " " + $vg_Label_TextBox.Text + "`r`n"` +`
                                                                                               "sudo mkfs.xfs /dev/" + $vg_Label_TextBox.Text + "/" + $lv_Label_TextBox.Text + "`r`n"` +`
                                                                                               "echo '/dev/mapper/" + $vg_Label_TextBox.Text + "-" + $lv_Label_TextBox.Text + "   " + $Mount_Point_Path_TextBox.Text + "   xfs   defaults   0 0' | sudo tee --append /etc/fstab > /dev/null" + "`r`n"` +`
                                                                                               "sudo mkdir -p " + $Mount_Point_Path_TextBox.Text + "`r`n"` +`
                                                                                               "sudo mount -a" + "`r`n"` +`
                                                                                               "sudo mount" + "`r`n"` +`
                                                                                               "df -h"
                                                                                               ""}
          "Extend Partion with New Drive"                      {$New_Drive_Var = $New_Drive_TextBox.Text
                                                                $vg_label_Var = $vg_Label_TextBox.Text
                                                                $lv_Label_Var = $lv_Label_TextBox.Text
                                                                $New_Drive_Partition_Number_Var = $New_Drive_Partition_Number_TextBox.Text
                                                                $Command_Output_TextBox.Text = "Loading..."
                                                                $Command_Output_TextBox.Text = "echo `"- - -`" | sudo tee /sys/class/scsi_host/host*/scan" + "`r`n" +`
                                                                                               "sudo parted --script /dev/$New_Drive_Var mklabel gpt mkpart primary '0%' '100%'" + "`r`n" +`
                                                                                               "sudo pvcreate /dev/$New_Drive_Var$New_Drive_Partition_Number_Var" + "`r`n" +`
                                                                                               "sudo vgextend $vg_label_Var /dev/$New_Drive_Var$New_Drive_Partition_Number_Var" + "`r`n" +`
                                                                                               "sudo vgdisplay $vg_label_Var | grep 'Free'" + "`r`n" +`
                                                                                               "sudo lvextend -l +100%FREE /dev/$vg_label_Var/$lv_Label_Var" + "`r`n" +`
                                                                                               "#sudo lvextend -L12G /dev/$vg_label_Var/$lv_Label_Var  # To extend the volume to a total 12 Gigs" + "`r`n" +`
                                                                                               "#sudo lvextend -L+1G /dev/$vg_label_Var/$lv_Label_Var  # To add just 1 gig to the volume" + "`r`n" +`
                                                                                               "sudo xfs_growfs /dev/$vg_label_Var/$lv_Label_Var" + "`r`n" +`
                                                                                               "df -h" + "`r`n" +`
                                                                                               ""}
          "Extend Partion by Extending Current Physical Drive" {$Old_Drive_Var = $Old_Drive_TextBox.Text
                                                                $vg_label_Var = $vg_Label_TextBox.Text
                                                                $lv_Label_Var = $lv_Label_TextBox.Text
                                                                $Old_Drive_Partition_Number_Var = $Old_Drive_Partition_Number_TextBox.Text
                                                                $Command_Output_TextBox.Text = "Loading..."
                                                                $Command_Output_TextBox.Text = "echo 1 | sudo tee /sys/class/block/$Old_Drive_Var/device/rescan" + "`r`n" +`
                                                                                               "sudo partx -u /dev/$Old_Drive_Var$Old_Drive_Partition_Number_Var" + "`r`n" +`
                                                                                               "echo fix | sudo parted /dev/$Old_Drive_Var ---pretend-input-tty print" + "`r`n" +`
                                                                                               "sudo parted --script /dev/$Old_Drive_Var resizepart $Old_Drive_Partition_Number_Var 100%" + "`r`n" +`
                                                                                               "sudo pvresize /dev/$Old_Drive_Var$Old_Drive_Partition_Number_Var" + "`r`n" +`
                                                                                               "sudo vgdisplay $vg_label_Var | grep 'Free'" + "`r`n" +`
                                                                                               "sudo lvextend -l +100%FREE /dev/$vg_label_Var/$lv_Label_Var" + "`r`n" +`
                                                                                               "#sudo lvextend -L12G /dev/$vg_label_Var/$lv_Label_Var  # To extend the volume to a total 12 Gigs" + "`r`n" +`
                                                                                               "#sudo lvextend -L+1G /dev/$vg_label_Var/$lv_Label_Var  # To add just 1 gig to the volume" + "`r`n" +`
                                                                                               "sudo xfs_growfs /dev/$vg_label_Var/$lv_Label_Var" + "`r`n" +`
                                                                                               "df -h" + "`r`n" +`
                                                                                               ""}
          Default                                              {$Command_Output_TextBox.Text = "Please Select Type"}

      }
  }
  )

  ## Cancel Button Action
  $CancelButton = New-Object Windows.Forms.Button -Property @{
      Location     = New-Object Drawing.Point 425, 550
      Size         = New-Object Drawing.Size 75, 23
      Text         = 'Cancel'
      DialogResult = [Windows.Forms.DialogResult]::Cancel
  }
  $form.CancelButton = $CancelButton
  $form.Controls.Add($CancelButton)

  ## Displays the form
  $result = $form.ShowDialog()

  
}

Run-Form
