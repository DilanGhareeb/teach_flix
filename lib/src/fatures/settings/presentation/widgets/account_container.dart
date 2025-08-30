import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:teach_flix/src/fatures/auth/domain/entities/user.dart';
import 'package:teach_flix/src/l10n/app_localizations.dart';

class AccountContainer extends StatelessWidget {
  final UserEntity? user;
  final VoidCallback? onTap;
  final Widget? leading;
  final Color? backgroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const AccountContainer({
    super.key,
    this.onTap,
    this.leading,
    this.backgroundColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.user,
  });

  @override
  Widget build(BuildContext context) {
    final applocalization = AppLocalizations.of(context)!;
    return Skeleton.replace(
      child: InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? BorderRadius.circular(25),
        child: Container(
          padding: padding ?? const EdgeInsets.all(15),
          width: width ?? double.infinity,
          height: height ?? 100,
          decoration: BoxDecoration(
            color:
                backgroundColor ??
                Theme.of(
                  context,
                ).appBarTheme.backgroundColor, // Set background color
            borderRadius: borderRadius ?? BorderRadius.circular(25),
            boxShadow: [
              // Optional: Add a subtle shadow
            ],
          ),
          child: Row(
            children: [
              Hero(
                tag: "profilePic",
                child:
                    leading ??
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: user?.profilePictureUrl ?? "",
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(
                            Icons.person,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          fit: BoxFit.cover,
                          width: 50,
                          height: 50,
                        ),
                      ),
                    ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(user?.name ?? applocalization.my_account),
                      if (user != null)
                        Text(
                          user?.email ?? applocalization.my_account,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
