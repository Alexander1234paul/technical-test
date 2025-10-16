# Lista de Pokémon con Preferencias

Se desarrollo una pequeña aplicación que permite consultar Pokémon desde una API pública y guardar tus favoritos (preferencias) de manera local.  
La idea fue aplicar buenas prácticas, mantener un código limpio y estructurado, y demostrar conocimientos en gestión de estado, arquitectura y UI.

---

## Descripción general

La aplicación carga una lista de Pokémon desde la PokéAPI y permite al usuario:
- Ver la lista completa con sus imágenes.
- Asignarles un nombre personalizado (por ejemplo: “Mi Pikachu Favorito”).
- Guardar y eliminar esas preferencias.
- Ver el detalle de cada preferencia guardada.

El diseño se basó en una estructura modular siguiendo el enfoque **Atomic Design** (atoms, molecules, organisms, pages), junto con **Cubit** para manejar el estado de manera sencilla y predecible.

---

## Requisitos y configuración inicial

1. Tener instalado **Flutter** (versión estable recomendada).  
2. Clonar el repositorio o descargar el proyecto.  
3. Ejecutar los siguientes comandos desde la terminal:

```bash
flutter pub get
flutter run
