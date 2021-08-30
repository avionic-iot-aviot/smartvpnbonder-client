### Obiettivi test Smart VPN Bonding (SVB)
L'obiettivo del test è quello di verificare l'efficacia dello SVB
attraverso l'invio di un flusso audio/video ad un server remoto ospitato da
Amazon Web Service.

### Componenti del testbed

I componenti del testbed sono:
 - RPI 4 con n° 2 dongle 3G/4G, con lo SVB attivo (mlvpn client + algoritmi smart)
 - VM EC2 su AWS che implementa la parte server dello SVB
 - VM EC2 su AWS che ospista il Gateway Janus (riceve lo stream audio/video dal client e lo memorizza su un file per
   successive elaborazioni)

### Modalità di svolgimento del test

Assicurarsi che tutti i servizi siano in esecuzione, in particolare:
 - VM EC2 con id [i-0a094ae9064807e11] e ssh-key [mvoip-tesisti.pem] deve eseguire la parte server di SVB
 - VM EC2 con id [i-0f1e92908668a46b9] e ssh-key [aviot-cora] deve eseguire il Gateway Janus
 - RPI 4 deve eseguire la parte client di SVB (si può utilizzare il servizio systemd o lanciarlo manualmente)

Per inviare il flusso video dal client [RPI 4] al Gateway Janus, utilizzare lo script `send-video.sh` presente
nella cartella `tests`:

`send-video.sh VIDEO_PATH JANUS_SRV JANUS_PORT_FEED`

dove `VIDEO_PATH` indica il path del video che si vuole trasmettere, `JANUS_SRV` punta all'indirizzo host della
macchina EC2 in cui è presente Janus Gateway e `JANUS_PORT_FEED` è la porta video in cui
Janus Gateway riceve il video UDP.

Dopo aver trasmesso il video, verificare che esso sia presente sul Gateway Janus con estensione `.mjr` e convertirlo
in `.mp4` col seguente comando:

`janus-pp-rec VIDEO.mjr VIDEO.mp4.`

#### Analisi qualità video

Per analizzare la qualità del video, viene utilizzato il tool [VMAF](https://github.com/Netflix/vmaf)

`vmaf -w 640 -h 480 -p 420 -b 8 -r reference-video.yuv -d distorted-video.yuv --output statistics.json --json`

Consigli:
  -  per trasformare un file .mp4 in `.yuv`, utilizzare `ffmpeg`:

`ffmpeg -i video.mp4 video.yuv`

  - il tool VMAF fornisce uno score da 0 a 100. Più è alto, più i due video sono simili (qualitativamente parlando)
  - il tool crea un file di statistiche `statistics.json` che fornisce parametri prestazionali frame per frame e globalmente (media)

### Video di riferimento

Il video di riferimento per i test è stato scaricato da:

https://sample-videos.com/

in particolare: https://sample-videos.com/video123/mp4/480/big_buck_bunny_480p_5mb.mp4


### Codifica nome file

Ogni file .mp4 è composto da diversi parametri. Esempio `bonding-smart-vpn-sim1-64000--sim2-8000--reorder-buffer-64.mp4`:

    - 64000 è il numero di bytes per i quali MLVPN utilizza la connessione SIM1
    - 8000 è il numero di bytes per i quali MLVPN utilizza la connessione SIM2
    - 64 (numero di pacchetti nel buffer per limitare il rate di pacchetti scartati perché arrivati fuori sequenza)
      è il valore del reoder-buffer impostato lato server

### Prelevare le caratteristiche del video

`ffprobe video.mp4`

### Generare le frame (jpg) a partire dal video .mp4

`ffmpeg -i video.mp4 -r 10 "$filename%03d.jpg"`

Il parametro -r indica il numero di frame da prendere ogni secondo.