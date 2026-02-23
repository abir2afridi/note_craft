import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.tertiary,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    size: 80,
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
                  ),
                ),
              ),
              title: Text(
                'STUDIO',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.3,
                            ),
                            blurRadius: 30,
                            offset: const Offset(0, 15),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.edit_note_rounded,
                        size: 70,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          AppConstants.appName,
                          style: theme.textTheme.displaySmall?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Version ${AppConstants.appVersion}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onPrimaryContainer,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildSectionHeader(theme, 'What is Note Craft?'),
                  const SizedBox(height: 16),
                  Text(
                    'Note Craft is a premium, minimal note-taking experience designed for clarity and focus. Built with state-of-the-art Flutter architecture.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSectionHeader(theme, 'Premium Features'),
                  const SizedBox(height: 16),
                  _buildFeatureTile(
                    theme,
                    Icons.offline_bolt_rounded,
                    'Offline First',
                    'Your notes are always accessible, even without internet.',
                  ),
                  _buildFeatureTile(
                    theme,
                    Icons.palette_rounded,
                    'Vibrant Themes',
                    'A rich collection of curated color palettes and wallpapers.',
                  ),
                  _buildFeatureTile(
                    theme,
                    Icons.security_rounded,
                    'Secure & Private',
                    'Your data stays yours, with local-first storage.',
                  ),
                  const SizedBox(height: 48),
                  Center(
                    child: Opacity(
                      opacity: 0.5,
                      child: Text(
                        '© 2026 NOTE CRAFT\nBuilt with passion and precision.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Text(
      title.toUpperCase(),
      style: theme.textTheme.labelLarge?.copyWith(
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
        color: theme.colorScheme.primary,
      ),
    );
  }

  Widget _buildFeatureTile(
    ThemeData theme,
    IconData icon,
    String title,
    String subtitle,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.5,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: theme.colorScheme.primary),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
