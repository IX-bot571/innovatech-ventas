# 💰 Backend - Módulo Ventas

Este módulo contiene la API desarrollada para la gestión de ventas e inventario de InnovaTech.

## 💾 2. Justificación de la Persistencia de Datos

Para garantizar que las transacciones comerciales, clientes y registros de ventas no se pierdan al reiniciar o actualizar los contenedores, se implementó una estrategia de persistencia mediante **Docker Volumes**.

### Elección Tecnológica: Named Volumes vs. Bind Mounts

Se optó explícitamente por el uso de **Named Volumes** (Volúmenes con Nombre) administrados por el motor de Docker para el servicio de base de datos, descartando los *Bind Mounts* por las siguientes razones de arquitectura:

1. **Seguridad y Permisos:** Evita los típicos errores de "Permission Denied" de Linux cuando el contenedor intenta escribir en carpetas del usuario local. Docker gestiona internamente los permisos del volumen de forma aislada y segura.
2. **Performance Relacional:** Los volúmenes con nombre aprovechan el rendimiento nativo de almacenamiento de Docker, reduciendo la latencia en consultas SQL pesadas en comparación con los montajes de directorios locales.
3. **Mantenimiento:** Facilita la migración de datos y actualizaciones de la versión del motor de base de datos sin riesgo de dañar los archivos del sistema anfitrión.

### Mapeo Implementado
* **Volumen:** `data_ventas_autonoma` (o el nombre definido en tu compose global) montado en la ruta de datos de la BD correspondiente.
