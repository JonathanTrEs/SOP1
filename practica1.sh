#Practica: Practica 1. Sistemas Operativos
#Alumno: Jonathan Trujillo Estévez
#Grupo: L8

argumentos=$# #todos los argumentos que hay 

#el bucle recorre cada argumento y ve si es -inf o -kill

for ((i=0;i < $argumentos ; i++)) #recorre cada argumento
do
    case $1 in  #segun lo que sea el parametro 1
      '-inf') mp=$(($2)) #se guarda la cantidad maxima de procesos
	      shift 2 #se desplaza dos pociciones para que el argumento 1 sea el -kill
		;;
      '-kill') ckill=$(($2))
		shift 2       #si el parametro es un -kill guardamos en ckill el numero de procesos que se matan
		;;	      
  esac #fin del case

done  #fin del for

#Recorre el numero de usuarios y los almacena en i. despues solo muestra el nombre del usuario porque esta recortado cut a partir
#del primer espacio que encuentre
for i in `who -u | cut -d' ' -f1` #tr -s ' ' |
do
  nombre=$(who | cut -d' ' -f1|sort -u) #guardamos el nombre del usuario que aparece en la primera columna haciendo who
  procesos=$(ps U $i --no-headers | wc -l) #en proceso se guarda la cantidad de procesos por usuario con el comando wc -l 
  procesos=$(($procesos - 2)) #se restan 2 uno porque el wc cuenta el 1º salto de linea y otro porque cuenta el proceso que se usa para #ejecutar el script
  fecha=$(ps a U $i -o start_time --no-headers | head -n 1) #pone la hora del proceso
  
# El --no-headers borra la linea de informacion de columna                                  
# head -n x saca las x primeras lineas

  echo  "Usuario : $nombre  Procesos: $procesos  Hora proceso mas antiguo: $fecha " #salida por pantalla 


#parte del inf
  if (("$procesos" > "$mp")); #comparacion del paso de parametros del inf
  then
    

      echo "$nombre usted tiene mas  procesos de los permitidos " #envia mensaje de aviso al usuario
      


#parte del kill

for ((i=0; i<$procesos - $ckill;i++)) #For para matar los procesos aleatoriamente. El for elimina los procesos hasta que solo queden los que le pasamos por el comando kill
do

  #p guarda el numero aleatorio , que sera el numero del proceso a matar.
  p=$(($RANDOM%$procesos)) #Random 
  
  
  pid=$(ps -o pid | head -$p | tail -1 | tr -s ' ' | cut -d' ' -f2 ) #se guarda el ppid del proceso para utilizar la señal kill
			#head imprime las n primeras lineas del ps siendo n el numero del proceso a matar		
			#tail imprime la ultima linea, hacer esto despues del head, imprime solo una unica linea que sera la del proceso a matar
			#cut mostramos solo el  ppid

    #accion de matar el proceso
    #kill $ppid
    echo "Proceso con pid  $pid matado "  
    
 done	#fin del for 

        fi #fin del if

 done  # fin del for de usuarios


  
  
