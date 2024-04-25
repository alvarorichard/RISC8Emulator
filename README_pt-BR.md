<p align="center">
  <img src="https://github.com/alvarorichard/RISC8Emulator/assets/102667323/e412c39b-04ce-4fa0-8f4f-1b180451694a" alt="Imagem logo" />
</p>

# RISC8Emulator
[![GitHub license](https://img.shields.io/github/license/alvarorichard/RISC8Emulator)](alvarorichard/RISC8Emulator/blob/master/LICENSE) ![GitHub stars](https://img.shields.io/github/languages/top/alvarorichard/RISC8Emulator) ![GitHub stars](https://img.shields.io/github/repo-size/alvarorichard/RISC8Emulator)


**RISC8Emulator** é uma recriação em software do sistema CHIP-8, um computador simples da metade dos anos 1970, usado principalmente para jogar videogames. Escrito em Zig, uma linguagem de programação moderna, este emulador replica a arquitetura e funcionalidade do CHIP-8 original, oferecendo uma experiência única para entusiastas de jogos retrô e história da computação.

## Recursos
- **Memória**: Emula os 4 KB de RAM do CHIP-8.
- **Display**: Simula o display monocromático de 64x32 pixels.
- **Contador de Programa (PC)**: Gerencia o fluxo do programa.
- **Registro de Índice (I)**: Um registro de 16 bits para apontar para locais de memória.
- **Pilha**: Utilizada para armazenar endereços de 16 bits para chamadas e retornos de funções.
- **Timer de Atraso**: Um timer de 8 bits que decrementa a uma taxa de 60 Hz.
- **Timer de Som**: Semelhante ao timer de atraso, mas emite um bip quando não está em zero.
- **Registros**: Compreende 16 registros de propósito geral de 8 bits (V0-VF).

## Estrutura de Arquivos
- `main.zig`: Ponto de entrada da aplicação, inicializando o emulador.
- `display.zig`: Gerencia o display monocromático do CHIP-8.
- `device.zig`: Integra componentes como memória e display.
- `cpu.zig`: Responsável pela funcionalidade da CPU e execução de instruções.
- **Arquivo `c.zig`**: Este arquivo é usado para importar a biblioteca SDL2 de C, facilitando a saída gráfica e o manuseio de entrada.
- `bitmap.zig`: Gerencia operações de bitmap para gráficos.

## Pré-requisitos
- Linguagem de programação Zig versão 0.11 instalada no seu sistema.
- **Requisito de ROM**: Para rodar um jogo, um arquivo de ROM CHIP-8 deve ser adicionado. Este emulador não vem com nenhum jogo pré-carregado, portanto, você precisa fornecer sua própria ROM.

## Instalação
1. Clone o repositório:
```bash
git clone https://github.com/alvarorichard/RISC8Emulator.git
```

1. Navegue até o diretório do projeto:
```bash
cd RISC8Emulator
```

## Executando o Emulador

Execute o arquivo main.zig com o compilador Zig para rodar o emulador:

```zig  
zig run main.zig
```

ou apenas execute:

```zig
zig build
```
## Contribuindo

Contribuições para melhorar ou aprimorar o emulador são sempre bem-vindas. Por favor, siga o processo padrão de solicitação de pull para contribuições.
