import 'dart:io';
import 'package:flutter/material.dart';
import '../themes/colors.dart';

class BookCard extends StatelessWidget {
  final String? imagePath;
  final String title;
  final double progress;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    this.imagePath,
    required this.title,
    required this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160, // Largura fixa ideal para listas horizontais
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Capa do Livro / Imagem
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Imagem de fundo ou Placeholder
                      _buildImage(),

                      // Degradê para escurecer um pouco o fundo da barra de progresso e dar destaque
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        height: 40,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withValues(alpha: 0.6),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Barra de Progresso
                      Positioned(
                        bottom: 12,
                        left: 12,
                        right: 12,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 6,
                            backgroundColor: AppColors.gray200.withValues(
                              alpha: 0.3,
                            ),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Título
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.light,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Progresso em Texto
                    Text(
                      '${(progress * 100).toInt()}% concluído',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: AppColors.gray200),
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Efeito de toque em todo o card
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    // Se o caminho da imagem for fornecido, tenta carregar o arquivo
    if (imagePath != null && imagePath!.isNotEmpty) {
      return Image.file(
        File(imagePath!),
        fit: BoxFit.cover,
        // Caso falhe de carregar a imagem (arquivo não existe, corrompido, etc) cai no errorBuilder
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }
    // Sem caminho, usa o default
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.primaryMedium, // Fundo cinza/escuro
      child: const Center(
        child: Icon(
          Icons
              .image_not_supported, // Ícone cinza mais escuro indicando fallback
          size: 48,
          color: AppColors.primaryDarkAccent,
        ),
      ),
    );
  }
}
