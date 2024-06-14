#!/bin/bash
# with debian-12.5.0-amd64-netinst.iso

# suppression de ce qui existe deja
# rm -f "/home/drhaouha/VirtualBox/VirtualBox VMs/Debian64_DISK.vdi"
# rm -rf "/home/drhaouha/VirtualBox/VirtualBox VMs/Debian64"


# Dans un premier temps, on ajoute la nouvelle VM avec la sous-commande createvm.
# Il faut spécifier le type d’OS et le chemin des fichiers de configuration de la VM sur le disque dur de la machine hôte.
VBoxManage createvm --name "Debian64" --ostype "Debian_64" --register --basefolder "/home/drhaouha/sgoinfre/Born2BeRoot"

# Puis on peut indiquer la quantité de mémoire RAM à utiliser ainsi que mémoire vidéo (vram).
# Éventuellement, on peut activer ioapic.
VBoxManage modifyvm Debian64 --memory 2048 --vram 128
VBoxManage modifyvm Debian64 --ioapic on

# Pour configurer la VM avec un réseau NAT :
VBoxManage modifyvm Debian64 --nic1 nat

# En bridge, ce sera plutôt :
#VBoxManage modifyvm Debian64 --bridgeadapter1 vmnet1
#VBoxManage modifyvm Debian64 --nic1 bridged

# Ensuite il faut créer le disque virtuel.
# On utilise la sous-commande createhd afin de créer le disque virtuel.
# Puis on créé le Controlleur Sata à la VM avec storagectl.
# Enfin on attache le disque virtuel à ce dernier avec storageattach.
VBoxManage createhd --filename "/home/drhaouha/sgoinfre/Born2BeRoot/Debian64_DISK.vdi" --size 15000 --format VDI                     
VBoxManage storagectl "Debian64" --name "SATA Controller" --add sata --controller IntelAhci       
VBoxManage storageattach "Debian64" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "/home/drhaouha/sgoinfre/Born2BeRoot/Debian64_DISK.vdi"

# Éventuellement on peut aussi ajouter un lecteur IDE qui fera office de lecteur DVD-Rom.
# A ce dernier, on peut attacher un fichier ISO.
VBoxManage storagectl "Debian64" --name "IDE Controller" --add ide --controller PIIX4       
VBoxManage storageattach "Debian64" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "/home/drhaouha/Documents/Born2beRoot_Docs/debian-12.5.0-amd64-netinst.iso"  
VBoxManage modifyvm "Debian64" --boot1 dvd --boot2 disk --boot3 none --boot4 none 

# Enfin pour installer l’OS automatiquement dans la VM en ligne de commandes, on utilise la commande unattended.
# Ci-dessous, on installe Debian depuis l’ISO debian-12.5.0-amd64-netinst.iso dans la VM Debian64.
# On peut spécifier le nom d’utilisateur (drhaouha) et son mot de passe (MonMotDePasse42).
#VBoxManage unattended install "Debian64" --iso "/home/drhaouha/Documents/Born2beRoot_Docs/debian-12.5.0-amd64-netinst.iso"  --user="drhaouha" --full-user-name="drhaouha42" --password "MonMotDePasse42" --install-additions --time-zone=UTC

# startvm command starts a virtual machine that is currently in the Powered Off or Saved states.
# The optional --type specifier determines whether the machine will be started in a window or whether the output should go through VBoxHeadless, with VRDE enabled or not. See VBoxHeadless, the Remote Desktop Server. The list of types is subject to change, and it is not guaranteed that all types are accepted by any product variant.
# The global or per-VM default value for the VM frontend type will be taken if the type is not explicitly specified. If none of these are set, the GUI variant will be started.
# The following values are allowed:
# gui
#     Starts a VM showing a GUI window. This is the default. 
# headless
#     Starts a VM without a window for remote display only. 
# separate
#     Starts a VM with a detachable UI. Technically, it is a headless VM with user interface in a separate process. This is an experimental feature as it lacks certain functionality, such as 3D acceleration. 

# Say we want to run the "Debian64" VM as a gui instance. To do this, you would issue the command:
# VBoxManage startvm "Debian64" --type gui

# If you need to pause that VM, issue the command:
#VBoxManage controlvm "Ubuntu Server" pause --type gui

# To shut down the VM, issue the command:
#VBoxManage controlvm "Ubuntu Server" poweroff --type gui
