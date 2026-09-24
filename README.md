# vhdl-cores

Colección de módulos VHDL educativos para practicar diseño digital y evolucionar hacia un pequeño núcleo tipo CPU.

> Estado: Inicial / Experimental. Las interfaces pueden cambiar.

---

## 📦 Módulos actuales

| Módulo / Carpeta | Archivo | Descripción breve | Estado / notas |
|------------------|------------------|-------------------|-------|
| ALU | `alu/rtl/alu.vhd` | Operaciones lógicas y aritméticas con flags | Experimental; requiere `rot`, que aún no está en el repositorio |
| Contador genérico | `common/rtl/myCnt2.vhd` | Contador con comparación y pulso de salida | Usado por la UART como generador de tick |
| Contador con carga paralela | `common/rtl/myCntBinarioPl.vhd` | Contador con enable y carga paralela | La interfaz usa un contador de dirección de 10 bits |
| UART Top | `uart/rtl/uart.vhd` | Integra transmisor y receptor | Enlaza `uartTx` y `uartRx` |
| UART TX | `uart/rtl/uartTx.vhd` | Transmisor UART bit a bit | Baud configurado mediante `sysClk/baudRate` |
| UART RX | `uart/rtl/uartRx.vhd` | Receptor UART secuencial | Sin oversampling |
| Program Counter | `pc/rtl/pc.vhd` | Incremento y carga paralela de dirección | Requiere `pcMem`, que aún no está incluido |
| Port IO | `common/rtl/portIO.vhd` | Registro simple de entrada y salida | Sin handshake |

---

## 🗂 Estructura

```
alu/rtl/           # Código ALU
uart/rtl/          # uart.vhd, uartTx.vhd, uartRx.vhd
pc/rtl/            # Program counter
common/rtl/        # Contadores y puerto de E/S compartidos
```

---

## ⚙️ Estado técnico y próximos ajustes

| Tema | Observación | Sugerencia |
|------|-------------|-----------|
| Librerías | En `alu.vhd` se usa `STD_LOGIC_UNSIGNED` (no estándar) | Reemplazar por `numeric_std` y usar `unsigned/signed` |
| Dependencias | `alu.vhd` instancia `rot` y `pc.vhd` instancia `pcMem`, pero esas entidades no están incluidas | Añadir las implementaciones o adaptar los módulos |
| Reset | Mezcla de `rst` y (potencial) asincrónico | Unificar: reset síncrono activo alto o `rst_n` activo bajo con sincronizador |
| Señales | `carryBorrow` combina carry y borrow | Podrías separar: `carry` y `borrow` o documentar semántica |
| Saturación | Lógica de saturación repetitiva | Centralizar en función o package |
| Flags | Se calculan tras multiplexar acc_d | Revisa condiciones de overflow y orden de evaluación |
| UART Baud | Usa un tick directo por bit | Mejorar con oversampling (x8/x16) para mayor robustez |
| Pruebas | Hay testbenches para contadores, `portIO` y UART | Completar pruebas para ALU y PC |
| Parametrización | `myCntBinarioPl` declara `N`, pero su interfaz mantiene 10 bits | Hacer que el ancho de datos use el generic |
| SPDX | Todos los fuentes VHDL deben conservar la licencia MIT | Mantener `-- SPDX-License-Identifier: MIT` como primera línea |

---

## 🧪 Simulación

Los testbenches están en `tb/`. El banco `uart_tb.vhd` usa la prueba UART
original del proyecto TPs-TD1; `tb_myCnt2.vhd`, `tb_myCntBinarioPl.vhd` y
`tb_portIO.vhd` incluyen aserciones automáticas.

Con Vivado Simulator:

```powershell
$vivado = "D:\AMDDesignTools\2025.2\Vivado\bin"
xvhdl.bat -2008 common/rtl/myCnt2.vhd common/rtl/myCntBinarioPl.vhd `
    common/rtl/portIO.vhd uart/rtl/uartTx.vhd uart/rtl/uartRx.vhd `
    uart/rtl/uart.vhd tb/tb_myCnt2.vhd tb/tb_myCntBinarioPl.vhd `
    tb/tb_portIO.vhd tb/uart_tb.vhd
xelab.bat work.tb_myCnt2 -s tb_myCnt2_sim
xsim.bat tb_myCnt2_sim --runall
```

El testbench de UART está orientado a inspección de ondas y finaliza con
`wait`; debe ejecutarse desde la interfaz gráfica de Vivado o detenerse
manualmente después de observar la transmisión y recepción.

---

## 🚀 Roadmap 

| Versión | Contenido | Estado |
|---------|-----------|--------|
| 0.0.5 | ALU + contador + UART TX/RX funcional básica | Experimental |
| 0.1.0 | Completar dependencias de ALU y PC | Pendiente |
| 0.2.0 | Testbenches (ALU, UART loopback, PC) + script de simulación | Pendiente |
| 0.3.0 | Refactor parametrizable + package de operaciones ALU | Pendiente |
| 0.4.0 | Oversampling UART + manejo error frame | Futuro |
| 0.5.0 | Integración parcial tipo CPU (fetch con PC + dummy decode) | Futuro |
| 0.6.0 | División en repos/ip si madura UART | Futuro |

---

## 📄 Licencia

Este proyecto está bajo la Licencia MIT. Consulta el archivo [LICENSE](LICENSE) para más detalles.

---

## 🤝 Contribuciones (futuro)

1. Crear rama `feature/<modulo>`.
2. Añadir módulo + testbench.
3. Incluir cabeceras SPDX.
4. PR con resultados de simulación (log / waveform opcional).

---

## ✉ Contacto

Autor: Enzo Nicolás Belmonte  

---