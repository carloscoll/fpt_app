my_fastapi_api/
│
├── app/                        # Carpeta principal de la aplicación
│   ├── __init__.py             # Inicializa el paquete de la aplicación
│   ├── main.py                 # Archivo principal de FastAPI
│   ├── dependencies.py         # Dependencias de la aplicación (opcional)
│   ├── models/                 # Modelos de base de datos
│   │   ├── __init__.py
│   │   └── your_model.py       # Define tus modelos aquí
│   ├── schemas/                # Esquemas Pydantic para validación de datos
│   │   ├── __init__.py
│   │   └── your_schema.py      # Define tus esquemas aquí
│   ├── api/                    # Endpoints de la API
│   │   ├── __init__.py
│   │   ├── v1/                 # Versión 1 de los endpoints de la API
│   │   │   ├── __init__.py
│   │   │   ├── endpoints/      # Endpoints específicos
│   │   │   │   ├── __init__.py
│   │   │   │   └── your_endpoint.py
│   │   │   └── router.py       # Router principal para la versión 1
│   │   └── ...                 # Otras versiones de la API
│   └── core/                   # Configuración y ajustes del core
│       ├── config.py           # Configuraciones (variables de entorno, etc.)
│       └── ...
│
├── tests/                      # Pruebas para la aplicación
│   ├── __init__.py
│   ├── test_main.py            # Pruebas del archivo main.py
│   └── ...
│
├── poetry.lock                 # Archivo lock generado por Poetry
├── pyproject.toml              # Configuración de Poetry y dependencias
└── README.md                   # Documentación del proyecto


Descripción de la Estructura

    Carpeta app/:
        Contiene la lógica central de tu API.
        main.py es donde configuras y lanzas tu aplicación FastAPI.
        models/ contiene tus modelos de base de datos (usando SQLAlchemy, por ejemplo).
        schemas/ alberga esquemas Pydantic para la validación de las entradas y salidas de tu API.
        api/ se utiliza para organizar tus endpoints, idealmente estructurados por versiones (como v1, v2, etc.) para facilitar la gestión y evolución de tu API.
        core/ incluye configuraciones globales y fundamentales de la aplicación.

    Carpeta tests/:
        Contiene pruebas para asegurar el correcto funcionamiento de tu API.

    poetry.lock y pyproject.toml:
        pyproject.toml configura Poetry y las dependencias de tu proyecto.
        poetry.lock asegura que las dependencias se mantengan consistentes.

    README.md:
        Documenta cómo instalar, ejecutar y usar tu API.