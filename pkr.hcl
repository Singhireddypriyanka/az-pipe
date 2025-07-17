packer {
  required_plugins {
    amazon = {
      source = "github.com/hashicorp/amazon"
      version = ">= 1.0.0"
    }
  }
}

source "virtualbox-iso" "win11" {
  iso_url            = "https://your-s3-public/windows11.iso"
  iso_checksum       = "sha256:<your-checksum>"
  communicator       = "winrm"
  winrm_username     = "Administrator"
  winrm_password     = "P@ssw0rd123"
  shutdown_command   = "shutdown /s /t 0 /f"
  vm_name            = "win11-packer"
  guest_os_type      = "Windows11_64"
  disk_size          = 61440
  headless           = true
  output_directory   = "output-windows11"
  vboxmanage = [
    ["modifyvm", "{{.Name}}", "--memory", "4096"],
    ["modifyvm", "{{.Name}}", "--cpus", "2"]
  ]

  boot_wait          = "10s"
  boot_command = [
    "<tab><enter>"
  ]

  floppy_files = [
    "Autounattend.xml",
    "scripts/setup.ps1"
  ]
}

build {
  sources = ["source.virtualbox-iso.win11"]

  provisioner "powershell" {
    scripts = ["scripts/setup.ps1"]
  }

  post-processor "amazon-import" {
    region       = "us-west-2"
    s3_bucket    = "your-import-bucket"
    license_type = "BYOL"
    role_name    = "vmimport"
  }
}
