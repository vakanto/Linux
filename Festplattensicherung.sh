#!/bin/bash
echo "========================================================================"
echo ***Festplattensicherung/-Wiederherstellung***
echo "========================================================================"
echo ""

Auswahl()
{
	echo "1. Sicherung von Partition"
	echo "2. Sicherung von MBR"
	echo "3- Sicherung von Datentraeger"

	echo ""
	echo ".."
	read choice
	
	mkdir -p ./Datensicherung
	
	case "$choice" in
	1)  choiceBoolean=1
		savePartition
		Auswahl;;

	2) 	choiceBoolean=2
		saveMBR
		Auswahl;;

	3) choiceBoolean=3
	saveDisk
	Auswahl;;

	*) 	echo ""
		echo ""
		echo "Fehlerhafte Eingabe"
		Auswahl;;

	esac
}


savePartition()
{    
  clear
  echo "Partitionsliste"
  echo "========================================================================"
  lsblk | grep sd
  echo ""
  echo "Eingabe: sd(BuchstabeNummer) für die gewuenschte Partition"
  echo "Beispiel: sda1 für erste Partition auf sda"
  echo ""
  read tempFile

  recoverPartition="$(  cat /proc/partitions | grep sd | awk ' {print $4}'  | grep $tempFile)"
  partitionSize="$(  cat /proc/partitions | grep $recoverPartition | awk ' {print $3}')"
  echo "Sicherung von : $recoverPartition $partitionSize MegaByte"

  if [ -n "$recoverPartition" ]; then
  #mkdir /mnt/$recoverPartition
  
  dd if=/dev/$"$recoverPartition" | pv -petra -s $( cat /proc/partitions | grep $tempFile | awk ' {print $3}')k | gzip -6 > ./Datensicherung/$recoverPartition.gz
  echo "+++++Die Partition wurde gesichert+++++"
  sleep 5
  clear

  else
  clear
  echo "Falsche Eingabe"
  sleep 2
  fi
}

saveMBR()
{
  echo "MBR wird gesichert"
  echo ""
  #Speicherung der ersten 512 Byte der Festplatte(Master Boot Record)
  dd if=/dev/sda1 bs=512 count=1 of=./Datensicherung/MBR.mbr
  echo ""
  echo "MBR wurde gesichert"
  sleep 5
  clear
}

saveDisk()
{
  clear
  echo "Datentraegerliste"
  echo "========================================================================"
  lsblk | grep ^sd
  echo ""
  echo "Eingabe: sd(Buchstabe) für den gewuenschten Datentraeger"
  echo "Beispiel: sda für Festplatte sda"
  echo ""
  read tempFile

  recoverPartition="$(  sed -ne 's/.*\([sh]d[a-zA-Z]\+$\)/\1/p' /proc/partitions | grep $tempFile)"
  echo "Sicherung von : $recoverPartition"

  if [ -n "$recoverPartition" ]; then
  #mkdir /mnt/$recoverPartition
  #pv zeigt den aktuellen Stand der Uebertragung an
  #cat gibt Informationen ueber Partitionen zurueck, 
  #
  dd if=/dev/$"$recoverPartition" | pv -petra -s $( cat /proc/partitions | grep $tempFile | awk ' {print $3}'| sed -n '1p')k | gzip -6 > $recoverPartition.gz
  echo "+++++Die Festplatte wurde gesichert+++++"
  sleep 5
  clear

  else
  clear
  echo "Falsche Eingabe"
  sleep 2
  fi


}

while((!choiceBoolean))
do
	Auswahl
done

read
