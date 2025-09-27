# vhdl-cores

Colección de módulos VHDL educativos (ALU, UART, Program Counter, bloques auxiliares como contadores, rotador, puerto de E/S). Orientado a consolidar práctica digital, simular con Vivado (xsim) y evolucionar hacia un pequeño núcleo tipo CPU educativa.

> Estado: Inicial / Experimental — Interfaces sujetas a cambios.

---

## 📦 Módulos actuales

| Módulo / Carpeta | Archivo principal | Descripción breve | Notas |
|------------------|------------------|-------------------|-------|
| ALU | `alu/rtl/alu.vhd` | Operaciones lógicas y aritméticas + flags (zero, overflow, carry/borrow, negative, saturación) | Usa rotador externo `rot.vhd` |
| Rotador | `common/rtl/rot.vhd` | Rotación condicional de un registro (17 bits) | Hard-codea longitudes (mejorar generics) |
| Contador genérico | `common/rtl/myCnt2.vhd` | Contador con comparación y pulso de salida | Usado como generador de “tick” para UART (baud) |
| Contador con carga paralela | `pc/rtl/myCntBinarioPl.vhd` | Contador con load (`dl`) y pre-carga | Ancho fijo interno 10 bits (q) |
| UART Top | `uart/rtl/uart.vhd` | Instancia transmisor y receptor | Enlaza `uartTx` + `uartRx` |
| UART TX | `uart/rtl/uartTx.vhd` | Transmisor bit a bit con máquina de estados | Baud = `sysClk/baudRate` |
| UART RX | `uart/rtl/uartRx.vhd` | Receptor secuencial con sample básico por tick de baud | No oversampling (mejorable) |
| Program Counter | `pc/rtl/pc.vhd` | Incremento + carga paralela (usa memoria) | Memoria `pcMem` (IP BRAM) |
| Port IO | `common/rtl/portIO.vhd` | Registro de E/S simple (read / write) | Sin handshake complejo |
| Memoria PC | `pc/rtl/pcMem_stub.vhd` | Stub para Block RAM | Reemplazar por IP Vivado o inferencia |

---

## 🗂 Estructura

```
packages/          # Futuro: core_pkg.vhd (tipos, opcodes)
alu/rtl/           # Código ALU
uart/rtl/          # uart.vhd, uartTx.vhd, uartRx.vhd
pc/rtl/            # Program counter + contador + memoria
common/rtl/        # Bloques compartidos (rot, contadores, IO)
uart/tb/           # Testbenches (por crear)
alu/tb/
pc/tb/
constraints/       # Archivos XDC
vivado/            # Scripts TCL para lotes
scripts/           # Scripts shell (simulaciones xsim)
```

---

## ⚙️ Recomendaciones de Estilo / Próximos Ajustes

| Tema | Observación | Sugerencia |
|------|-------------|-----------|
| Librerías | En `alu.vhd` se usa `STD_LOGIC_UNSIGNED` (no estándar) | Reemplazar por `numeric_std` y usar `unsigned/signed` |
| Generics | Algunos anchos fijos (rotador 17 bits) | Introducir generic `G_WIDTH` y validar desplazamiento |
| Reset | Mezcla de `rst` y (potencial) asincrónico | Unificar: reset síncrono activo alto o `rst_n` activo bajo con sincronizador |
| Señales | `carryBorrow` combina carry y borrow | Podrías separar: `carry` y `borrow` o documentar semántica |
| Saturación | Lógica de saturación repetitiva | Centralizar en función o package |
| Flags | Se calculan tras multiplexar acc_d | Revisa condiciones de overflow y orden de evaluación |
| UART Baud | Usa un tick directo por bit | Mejorar con oversampling (x8/x16) para mayor robustez |
| PC Mem | Memoria externa no incluida | Añadir stub o inferir RAM (synchronous read) |
| División de responsabilidades | Top UART re-instancia TX/RX sin señales internas documentadas | Añadir README específico en `uart/` con diagrama temporal |
| Pruebas | No hay testbenches aún en repo | Crear `tb_alu.vhd`, `tb_uart_loopback.vhd`, etc. |
| SPDX | Sin cabecera en archivos | Añadir `-- SPDX-License-Identifier: MIT` (u otra) primera línea |

---

## 🧪 Simulación (Vivado xsim)

Ejemplo rápido (ALU):

```bash
cd alu/rtl
xvhdl -2008 ../../packages/*.vhd alu.vhd ../tb/tb_alu.vhd
xelab tb_alu -s tb_alu_sim
xsim tb_alu_sim --runall
```

---

## 🚀 Roadmap 

| Versión | Contenido | Estado |
|---------|-----------|--------|
| 0.0.5 | ALU + contador + UART TX/RX funcional básica | Experimental |
| 0.1.0 | ALU + contador + UART TX/RX funcional básica + PC | Pendiente |
| 0.2.0 | Testbenches (ALU, UART loopback, PC) + script xsim | Pendiente |
| 0.3.0 | Refactor rotador parametrizable + package de operaciones ALU | Pendiente |
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