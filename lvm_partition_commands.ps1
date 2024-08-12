## Hide PowerShell Console
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();
[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
$consolePtr = [Console.Window]::GetConsoleWindow()
[Console.Window]::ShowWindow($consolePtr, 0)



function Run-Form {
  ## Builds the form
  Add-Type -AssemblyName System.Windows.Forms
  Add-Type -AssemblyName System.Drawing

  $form = New-Object Windows.Forms.Form -Property @{
      StartPosition = [Windows.Forms.FormStartPosition]::CenterScreen
      Size          = New-Object Drawing.Size 900, 665
      Text          = 'LVM - Modify Drives'
      Topmost       = $true
  }
  ########################################################################
  ########################################################################
  $LVM_Extensions_Senario_ListBox_Label = New-Object System.Windows.Forms.Label -Property @{
      Location     = New-Object Drawing.Point 10, 20
      Size         = New-Object System.Drawing.Size(450,20)
      Text         = "Pick the partiton senario:"
  }
  $form.Controls.Add($LVM_Extensions_Senario_ListBox_Label)
  
  $LVM_Extensions_Type_ListBox = New-Object System.Windows.Forms.ListBox -Property @{
      Location     = New-Object Drawing.Point 10, 40
      Size         = New-Object System.Drawing.Size(450,65)
  }

  $LVM_Extensions_Type_ListBox.Items.Add("Create New Physical Drive VG LV and Mount")
  $LVM_Extensions_Type_ListBox.Items.Add("Create New Physical Drive and Extend Existing VG LV")
  $LVM_Extensions_Type_ListBox.Items.Add("Extend Existing Drive VG and LV")
  $LVM_Extensions_Type_ListBox.Items.Add("Extend Existing Drive and Add New LV Mount to Existing VG")
  $form.Controls.Add($LVM_Extensions_Type_ListBox)
  ########################################################################
  ########################################################################
  $New_Drive_Label = New-Object System.Windows.Forms.Label -Property @{
      Location     = New-Object Drawing.Point 10, 110
      Size         = New-Object System.Drawing.Size(450,20)
      Text         = 'Enter NEW Drive. Example "sdc"'
  }

  $New_Drive_TextBox = New-Object System.Windows.Forms.TextBox -Property @{
      Location     = New-Object Drawing.Point 10, 130
      Size         = New-Object System.Drawing.Size(450,20)
      Text         = 'sdc'
  }
  ########################################################################
  ########################################################################
  $Existing_Drive_Label = New-Object System.Windows.Forms.Label -Property @{
      Location          = New-Object Drawing.Point 10, 110
      Size              = New-Object System.Drawing.Size(450,20)
      Text              = 'Enter the EXISTING Drive name that was just enlarged in vCenter. Example "sda"'
  }

  $Existing_Drive_TextBox = New-Object System.Windows.Forms.TextBox -Property @{
      Location            = New-Object Drawing.Point 10, 130
      Size                = New-Object System.Drawing.Size(450,20)
      Text                = "sda"
  }
  ########################################################################
  ########################################################################
  $New_vg_Label = New-Object System.Windows.Forms.Label -Property @{
      Location  = New-Object Drawing.Point 10, 160
      Size      = New-Object System.Drawing.Size(450,20)
      Text      = 'Enter NEW Volume Group Name. Example "vg_test"'
  }

  $New_vg_TextBox = New-Object System.Windows.Forms.TextBox -Property @{
      Location    = New-Object Drawing.Point 10, 180
      Size        = New-Object System.Drawing.Size(450,20)
      Text        = 'vg_'
  }
  ########################################################################
  ########################################################################
  $Existing_vg_Label = New-Object System.Windows.Forms.Label -Property @{
      Location  = New-Object Drawing.Point 10, 160
      Size      = New-Object System.Drawing.Size(450,20)
      Text      = 'Enter EXISTING Volume Group Name. Example "vg_test"'
  }

  $Existing_vg_TextBox = New-Object System.Windows.Forms.TextBox -Property @{
      Location    = New-Object Drawing.Point 10, 180
      Size        = New-Object System.Drawing.Size(450,20)
      Text        = 'vg_'
  }
  ########################################################################
  ########################################################################
  $New_lv_Label = New-Object System.Windows.Forms.Label -Property @{
      Location  = New-Object Drawing.Point 10, 210
      Size      = New-Object System.Drawing.Size(450,20)
      Text      = 'Enter NEW Logical Volume Name. Example "lv_test"'
  }

  $New_lv_TextBox = New-Object System.Windows.Forms.TextBox -Property @{
      Location    = New-Object Drawing.Point 10, 230
      Size        = New-Object System.Drawing.Size(450,20)
      Text        = 'lv_'
  }
  ########################################################################
  ########################################################################
  $Existing_lv_Label = New-Object System.Windows.Forms.Label -Property @{
      Location  = New-Object Drawing.Point 10, 210
      Size      = New-Object System.Drawing.Size(450,20)
      Text      = 'Enter EXISTING Logical Volume Name. Example "lv_test"'
  }

  $Existing_lv_TextBox = New-Object System.Windows.Forms.TextBox -Property @{
      Location    = New-Object Drawing.Point 10, 230
      Size        = New-Object System.Drawing.Size(450,20)
      Text        = 'lv_'
  }
  ########################################################################
  ########################################################################
  $New_Mount_Point_Label = New-Object System.Windows.Forms.Label -Property @{
      Location           = New-Object Drawing.Point 10, 260
      Size               = New-Object System.Drawing.Size(450,20)
      Text               = 'Enter NEW Mount Point Path. Example "/opt/test"'
  }

  $New_Mount_Point_TextBox = New-Object System.Windows.Forms.TextBox -Property @{
      Location             = New-Object Drawing.Point 10, 280
      Size                 = New-Object System.Drawing.Size(450,20)
      Text                 = ''
  }
  ########################################################################
  ########################################################################
  $Existing_Drive_Partition_Number_Label = New-Object System.Windows.Forms.Label -Property @{
      Location     = New-Object Drawing.Point 10, 310
      Size         = New-Object System.Drawing.Size(450,20)
      Text         = 'Enter the LAST EXISTING Partition Number of drive that was just enlarged. Example "2"'
  }

  $Existing_Drive_Partition_Number_TextBox = New-Object System.Windows.Forms.TextBox -Property @{
      Location     = New-Object Drawing.Point 10, 330
      Size         = New-Object System.Drawing.Size(450,20)
      Text         = '2'
  }
  ########################################################################
  ########################################################################
  $Hint_Label = New-Object System.Windows.Forms.Label -Property @{
      Location     = New-Object Drawing.Point 480, 200
      Size         = New-Object System.Drawing.Size(400,40)
      Text         = 'Hint:  Use the comand "lsblk" to get the Volume Group, Logical Volume and Partion numbers'
  }
  $form.Controls.Add($Hint_Label)
  ########################################################################
  ########################################################################
  $Command_Output_Label = New-Object System.Windows.Forms.Label -Property @{
      Location     = New-Object Drawing.Point 10, 360
      Size         = New-Object System.Drawing.Size(450,20)
      Text         = 'Command Output:'
  }
  $form.Controls.Add($Command_Output_Label)

  $Command_Output_TextBox = New-Object System.Windows.Forms.TextBox -Property @{
      Multiline    = $True;
      Scrollbars   = "Vertical"
      Location     = New-Object Drawing.Point 10, 380
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
      $form.Controls.Remove($Existing_Drive_Label)
      $form.Controls.Remove($Existing_Drive_TextBox)
      $form.Controls.Remove($New_vg_Label)
      $form.Controls.Remove($New_vg_TextBox)
      $form.Controls.Remove($Existing_vg_Label)
      $form.Controls.Remove($Existing_vg_TextBox)
      $form.Controls.Remove($New_lv_Label)
      $form.Controls.Remove($New_lv_TextBox)
      $form.Controls.Remove($Existing_lv_Label)
      $form.Controls.Remove($Existing_lv_TextBox)
      $form.Controls.Remove($New_Mount_Point_Label)
      $form.Controls.Remove($New_Mount_Point_TextBox)
      $form.Controls.Remove($Existing_Drive_Partition_Number_Label)
      $form.Controls.Remove($Existing_Drive_Partition_Number_TextBox)
      $Command_Output_TextBox.Text = ""
      $LVM_Extensions_Type_ListBox_Selection = $LVM_Extensions_Type_ListBox.SelectedItem.ToString()
      switch ($LVM_Extensions_Type_ListBox_Selection)
      {
          "Create New Physical Drive VG LV and Mount"                 {$form.Controls.Add($New_Drive_Label)
                                                                       $form.Controls.Add($New_Drive_TextBox)
                                                                       $form.Controls.Add($New_vg_Label)
                                                                       $form.Controls.Add($New_vg_TextBox)
                                                                       $form.Controls.Add($New_lv_Label)
                                                                       $form.Controls.Add($New_lv_TextBox)
                                                                       $form.Controls.Add($New_Mount_Point_Label)
                                                                       $form.Controls.Add($New_Mount_Point_TextBox)}
          "Create New Physical Drive and Extend Existing VG LV"       {$form.Controls.Add($New_Drive_Label)
                                                                       $form.Controls.Add($New_Drive_TextBox)
                                                                       $form.Controls.Add($Existing_vg_Label)
                                                                       $form.Controls.Add($Existing_vg_TextBox)
                                                                       $form.Controls.Add($Existing_lv_Label)
                                                                       $form.Controls.Add($Existing_lv_TextBox)}
          "Extend Existing Drive VG and LV"                           {$form.Controls.Add($Existing_Drive_Label)
                                                                       $form.Controls.Add($Existing_Drive_TextBox)
                                                                       $form.Controls.Add($Existing_vg_Label)
                                                                       $form.Controls.Add($Existing_vg_TextBox)
                                                                       $form.Controls.Add($Existing_lv_Label)
                                                                       $form.Controls.Add($Existing_lv_TextBox)
                                                                       $form.Controls.Add($Existing_Drive_Partition_Number_Label)
                                                                       $form.Controls.Add($Existing_Drive_Partition_Number_TextBox)}
          "Extend Existing Drive and Add New LV Mount to Existing VG" {$form.Controls.Add($Existing_Drive_Label)
                                                                       $form.Controls.Add($Existing_Drive_TextBox)
                                                                       $form.Controls.Add($Existing_vg_Label)
                                                                       $form.Controls.Add($Existing_vg_TextBox)
                                                                       $form.Controls.Add($New_lv_Label)
                                                                       $form.Controls.Add($New_lv_TextBox)
                                                                       $form.Controls.Add($New_Mount_Point_Label)
                                                                       $form.Controls.Add($New_Mount_Point_TextBox)
                                                                       $form.Controls.Add($Existing_Drive_Partition_Number_Label)
                                                                       $form.Controls.Add($Existing_Drive_Partition_Number_TextBox)}
          Default                                                     {$Command_Output_TextBox.Text = "Please Select Senario"}
      }
  }
  )
  ########################################################################
  ########################################################################
  ## Add Run Button
  $RunFormButton = New-Object Windows.Forms.Button -Property @{
      Location     = New-Object Drawing.Point 350, 590
      Size         = New-Object Drawing.Size 75, 23
      Text         = 'Run'
  }
  $form.Controls.Add($RunFormButton)
  
  
  ## Add Run Button click event
  $RunFormButton.Add_Click(
  {
      try { 
          $LVM_Extensions_Type_ListBox_Selection = $LVM_Extensions_Type_ListBox.SelectedItem.ToString()
      }
      catch {
          $Command_Output_TextBox.Text = "Please Select Senario"
      }
      switch ($LVM_Extensions_Type_ListBox_Selection)
      {
          "Create New Physical Drive VG LV and Mount"                 {$Drive_Var = $New_Drive_TextBox.Text
                                                                       $vg_Var = $New_vg_TextBox.Text
                                                                       $lv_Var = $New_lv_TextBox.Text
                                                                       $Mount_Var = $New_Mount_Point_TextBox.Text
                                                                       $Command_Output_TextBox.Text = "Loading..."
                                                                       $Command_Output_TextBox.Text = "echo `"- - -`" | sudo tee /sys/class/scsi_host/host*/scan" + "`r`n" +`
                                                                                                      "sudo parted --script /dev/$Drive_Var mklabel gpt mkpart primary '0%' '100%'" + "`r`n" +`
                                                                                                      "sudo pvcreate /dev/$Drive_Var" + "1" + "`r`n" +`
                                                                                                      "sudo vgcreate $vg_Var /dev/$Drive_Var" + "1" + "`r`n" +`
                                                                                                      "sudo lvcreate -l 100%VG -n $lv_Var $vg_Var" + "`r`n" +`
                                                                                                      "sudo mkfs.xfs /dev/$vg_Var/$lv_Var" + "`r`n" +`
                                                                                                      "echo '/dev/mapper/$vg_Var-$lv_Var   $Mount_Var   xfs   defaults   0 0' | sudo tee --append /etc/fstab > /dev/null" + "`r`n" +`
                                                                                                      "sudo mkdir -p $Mount_Var" + "`r`n" +`
                                                                                                      "sudo mount -a" + "`r`n"` +`
                                                                                                      "sudo mount" + "`r`n" +`
                                                                                                      "df -h" + "`r`n" +`
                                                                                                      ""}
          "Create New Physical Drive and Extend Existing VG LV"       {$Drive_Var = $New_Drive_TextBox.Text
                                                                       $vg_Var = $Existing_vg_TextBox.Text
                                                                       $lv_Var = $Existing_lv_TextBox.Text
                                                                       $Command_Output_TextBox.Text = "Loading..."
                                                                       $Command_Output_TextBox.Text = "echo `"- - -`" | sudo tee /sys/class/scsi_host/host*/scan" + "`r`n" +`
                                                                                                      "sudo parted --script /dev/$Drive_Var mklabel gpt mkpart primary '0%' '100%'" + "`r`n" +`
                                                                                                      "sudo pvcreate /dev/$Drive_Var" + "1" + "`r`n" +`
                                                                                                      "sudo vgextend $vg_Var /dev/$Drive_Var" + "1" + "`r`n" +`
                                                                                                      "sudo vgdisplay $vg_Var | grep 'Free'" + "`r`n" +`
                                                                                                      "sudo lvextend -l +100%FREE /dev/$vg_Var/$lv_Var" + "`r`n" +`
                                                                                                      "#sudo lvextend -L12G /dev/$vg_Var/$lv_Var  # To extend the volume to a total 12 Gigs" + "`r`n" +`
                                                                                                      "#sudo lvextend -L+1G /dev/$vg_Var/$lv_Var  # To add just 1 gig to the volume" + "`r`n" +`
                                                                                                      "sudo xfs_growfs /dev/$vg_Var/$lv_Var" + "`r`n" +`
                                                                                                      "df -h" + "`r`n" +`
                                                                                                      ""}
          "Extend Existing Drive VG and LV"                           {$Drive_Var = $Existing_Drive_TextBox.Text
                                                                       $vg_Var = $Existing_vg_TextBox.Text
                                                                       $lv_Var = $Existing_lv_TextBox.Text
                                                                       $Drive_Partition_Number_Var = $Existing_Drive_Partition_Number_TextBox.Text
                                                                       $Command_Output_TextBox.Text = "Loading..."
                                                                       $Command_Output_TextBox.Text = "echo 1 | sudo tee /sys/class/block/$Drive_Var/device/rescan" + "`r`n" +`
                                                                                                      "sudo partx -u /dev/$Drive_Var$Drive_Partition_Number_Var" + "`r`n" +`
                                                                                                      "echo fix | sudo parted /dev/$Drive_Var ---pretend-input-tty print" + "`r`n" +`
                                                                                                      "sudo parted --script /dev/$Drive_Var resizepart $Drive_Partition_Number_Var 100%" + "`r`n" +`
                                                                                                      "sudo pvresize /dev/$Drive_Var$Drive_Partition_Number_Var" + "`r`n" +`
                                                                                                      "sudo vgdisplay $vg_Var | grep 'Free'" + "`r`n" +`
                                                                                                      "sudo lvextend -l +100%FREE /dev/$vg_Var/$lv_Var" + "`r`n" +`
                                                                                                      "#sudo lvextend -L12G /dev/$vg_Var/$lv_Var  # To extend the volume to a total 12 Gigs" + "`r`n" +`
                                                                                                      "#sudo lvextend -L+1G /dev/$vg_Var/$lv_Var  # To add just 1 gig to the volume" + "`r`n" +`
                                                                                                      "sudo xfs_growfs /dev/$vg_Var/$lv_Var" + "`r`n" +`
                                                                                                      "df -h" + "`r`n" +`
                                                                                                      ""}
          "Extend Existing Drive and Add New LV Mount to Existing VG" {$Drive_Var = $Existing_Drive_TextBox.Text
                                                                       $vg_Var = $Existing_vg_TextBox.Text  
                                                                       $lv_Var = $New_lv_TextBox.Text
                                                                       $Mount_Var = $New_Mount_Point_TextBox.Text
                                                                       $Drive_Partition_Number_Var = $Existing_Drive_Partition_Number_TextBox.Text
                                                                       $Command_Output_TextBox.Text = "Loading..."
                                                                       $Command_Output_TextBox.Text = "echo 1 | sudo tee /sys/class/block/$Drive_Var/device/rescan" + "`r`n" +`
                                                                                                      "sudo partx -u /dev/$Drive_Var$Drive_Partition_Number_Var" + "`r`n" +
                                                                                                      "echo fix | sudo parted /dev/$Drive_Var ---pretend-input-tty print" + "`r`n" +`
                                                                                                      "sudo parted --script /dev/$Drive_Var resizepart $Drive_Partition_Number_Var 100%" + "`r`n" +`
                                                                                                      "sudo pvresize /dev/$Drive_Var$Drive_Partition_Number_Var" + "`r`n" +`
                                                                                                      "sudo vgdisplay $vg_Var | grep 'Free'" + "`r`n" +`
                                                                                                      "sudo lvcreate -l 100%VG -n $lv_Var $vg_Var" + "`r`n" +`
                                                                                                      "sudo mkfs.xfs /dev/$vg_Var/$lv_Var" + "`r`n" +`
                                                                                                      "echo '/dev/mapper/$vg_Var-$lv_Var   $Mount_Var   xfs   defaults   0 0' | sudo tee --append /etc/fstab > /dev/null" + "`r`n" +`
                                                                                                      "sudo mkdir -p $Mount_Var" + "`r`n" +`
                                                                                                      "sudo mount -a" + "`r`n" +`
                                                                                                      "sudo mount" + "`r`n" +`
                                                                                                      "df -h" + "`r`n" +`
                                                                                                      ""}
          Default                                                     {$Command_Output_TextBox.Text = "Please Select Senario"}

      }
  }
  )
  ########################################################################
  ########################################################################
  ## Cancel Button Action
  $CancelButton = New-Object Windows.Forms.Button -Property @{
      Location     = New-Object Drawing.Point 425, 590
      Size         = New-Object Drawing.Size 75, 23
      Text         = 'Cancel'
      DialogResult = [Windows.Forms.DialogResult]::Cancel
  }
  $form.CancelButton = $CancelButton
  $form.Controls.Add($CancelButton)
  ########################################################################
  ########################################################################
  
  ## Displays the form
  $result = $form.ShowDialog()

  
}

Run-Form
