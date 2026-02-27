import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context, isDark),
                  const SizedBox(height: 24),
                  _buildTrendingManga(context),
                  const SizedBox(height: 32),
                  _buildLatestUpdates(context, isDark),
                  const SizedBox(height: 32),
                  _buildRecommendedGrid(context),
                ],
              ),
            ),
            _buildBottomNav(context, isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(isDark ? 0.05 : 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search manga...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Stack(
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none),
                color: isDark ? Colors.white70 : Colors.black87,
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.primary.withOpacity(0.2),
                width: 2,
              ),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://lh3.googleusercontent.com/aida-public/AB6AXuAOmebCcL-tBf75LvGc6ipwfwsOuoOk0JHFI9_-bxtFtzxg-Gvn9k6VI8MliWvYzLg-xAeQ0SagmyxKKE1Z_36s2wkff5JPgMEk5XhogzNBDh-vl1XFdn6pGT9Spt-6zIdcPzfQewpZYs-2jpZ_47qkNM163fNM3IqQYOQzFQcEA10umHVOHOxSCj7ZoHIeGZ-VAH5EcWQiV9sXiomk3tZR36v18pacx1xwmqmWlEo7MrOgSh2JYUQwJxqkICkhRDy2n0dALOilShrw',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingManga(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Trending Manga',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View all',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildTrendingItem(
                context,
                'Shadow Monarch',
                'Action, Fantasy • Ch. 182',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBL-exf3KEGn8aBTjUL7DAHE-BN9sf-HJv34-RiddywI_vT69JheMWwYURcp1cXXWQYsuyhTEFhXL7u-6rRJwmj6Ho5Ge_H1C3lc5luBus472xXuaIibPmeWaewH_xgeUhBn5h0aeh90_RgZNf4OhvBSBDkAzmrU7VlM3rbCpjlLzGFQyMtJiiWNSCPC_qNTwmhWpY7Nga2p99bY3Fqh0JSGzg3KdYzs1wCmDwpI6SJCuufykc-vHr19d55XUfPu4hHFSixKetb_0XX',
                'Hot',
              ),
              _buildTrendingItem(
                context,
                'Neo Tokyo 2099',
                'Sci-Fi, Cyberpunk • Ch. 45',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCvdsb9pMjR5obm2s0a7Ug2y3WgNqjMmloRz3ixuTTHRWXDt2vOKWkUp75bXL8X69BZe-1g0xkpOaFhLJRIyvBnzCDlNbYDQfzugkW8lZGs5K39BiCfTFIgkOH9pRy41zzmOf6-DJxL_1uEbtB0bb1q6htdCGvsWOzSrattIL9zAzemPKSh5Of-5cL2Ohq7iRgFhHIprZbbM-11rvveo92lGwO1iDeIpZAqgocXCKz8tdmfHtu5q5Oq5HjH9nYjG4iWOeCLJCjwqWVb',
                'Top #1',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingItem(
    BuildContext context,
    String title,
    String subtitle,
    String imageUrl,
    String tag,
  ) {
    return Container(
      width: 180,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(16),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 12,
                    left: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestUpdates(BuildContext context, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Latest Update',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Today',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildUpdateItem(
            'The Alchemist\'s Burden',
            'Chapter 124: The Final Sacrifice',
            '2 hours ago',
            'https://lh3.googleusercontent.com/aida-public/AB6AXuApyDdiu_3TwM0cYeBld0OxfPJ_2s1Zp_k5j70TzXe7oZEPzOQj34yXpJzOgL1so9s-W7lMmvgnwmCY1NAHwZihRRakWj9Fv48HeMQkRYDbPBItUSG5AP03Uv76h6JY0cqYlk8RXYE7nQEvtnqRkFCYtUbKtqIrCAR832LZqhNyUazWPKwOfdXKgUmWBnkRU4dqovBJ01BtDmdX1EExMuVPUXP7Lzy4_YjO_P7XDsl8kN5_G8sSa34Xog6s--EVMAMPhJFnWb1R-Gfr',
            isDark,
          ),
          const SizedBox(height: 12),
          _buildUpdateItem(
            'Broken Blade Chronicles',
            'Chapter 89: Echoes of Steel',
            '5 hours ago',
            'https://lh3.googleusercontent.com/aida-public/AB6AXuB_AarrLouFaD4dTp6GWD1zDfFG2hO5rIObvBkXS44d3GBDCKWdDD_SnNEJ9pJSV9LsG7IXFHHx0qIsjQyIiReZZ3s0F3RVoCwGWeB3FL_mslQC6Fc8abn7c52rXRns1r2XzOouNyeRw7XYxOv1Yb91F0k43MNSzIeXooBeHDWux6iyVSdG6JpfX5nhbQXHJIbyG1lxTvKXa4wGCD-uWRv5TP3ldpHGyHuKxEUPKgWg2CYkDucXNbLPFe6q6J9cbU0xncQvfTlmogf4',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildUpdateItem(
    String title,
    String chapter,
    String time,
    String imageUrl,
    bool isDark,
  ) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl,
              width: 60,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'NEW',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  chapter,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.bookmark_add_outlined, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recommended for You',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            mainAxisSpacing: 16,
            crossAxisSpacing: 12,
            childAspectRatio: 0.6,
            children: [
              _buildRecommendedItem(
                'Way of the Spirit',
                '4.9',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuAFybQZbfC9g2tBjdsXjyR8MID_sSvuyQ8mx5uwceHCnHnIL8b6lJF6TiV01CLpbLKOepjFCQbK_J_NYRNwrvpzETQfXf4b7HC4KHh4E63UKw-hW-M_nqfZzxqiMxk2a30SmonpxwOHFxUPG4-h_GusOltfTantZgmXyKW-CQoDZeWlb51RCkT2wihwxMgNE2zbKi2mWzVvK5MUGhxpEzCIsrAYkf29Xoy4MS1dVuMfGJR9sKF6gJsgQYyrgUbwrjPY8jKktFMBA7vO',
              ),
              _buildRecommendedItem(
                'Colors in Motion',
                '4.7',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBTmLUeixEEBlqZtBS3eq_n29EW4YoxquutdggrzBE9u5eAFlqEedtpGB6pPrhBakPw_v26rpY-Ty2nW0SBd2xIWUKMUKvIJC39lyq0p-RbG596wHKCvXuolU4u8YtYoJ3_yeNHwghVHSDhIx7xE3iQdIZcya-Ten4QY8HfcQUbmucki_2uqTlHmIqFp2tucP_YJX2617JfofpsKdWxlw4kNhA988u5vrlwl0ZdMX889YEArHJwrwh1cfwqZ3sY29ldjnO0k8yELffg',
              ),
              _buildRecommendedItem(
                'Moonlit Assassin',
                '4.8',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuBisGcQN_cIpHqVO-C4sjWCH-4iwR6-wMqBpaw-tX-hwJzzO6vqVAlPpTaXCX7ehB0pKFO_GgUnhGJxWx2jVBXWwevbO4kLKvDieD_MLwsRKDevR34yFEjWG_Yvu0sytsVY1BT1a5lWhYlg3yMC8e-eo5NNxvMVNhxm-xTsmXPgoVaceAbf5qNruV_R8KOyhEa_bfO5h1twUqCVVQl0aQLc7x479U5zcYUHVmpsuJpgrgpnomSJ-mtZokls9slzAicnXuJlsB7Klb6E',
              ),
              _buildRecommendedItem(
                'Lost in Ether',
                '4.5',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCLlq938KmgrVef9bxlYgPVHaJovjoslqz4VrQ5QfnI8W0cIhxo7HlIcHiilhqQFipHKxGsnRJBJ-AzZCrNKgINfM1QPagTzws_6PEI3CuQ55m1_83kRc9c_8VyPTRZYX4yFbn76SHp3ObtC3LgR2tTZ2_5AM9O30nShIPnt08HiVqo9f6CsXm4en98a47TzUI-r0RSs1nh9PgKRBetRic_sCJ_z9MjrHI4YcIvpNzBRRZkAcuQmoilNf2GM0WHXkc2n3N93Rb_CTyP',
              ),
              _buildRecommendedItem(
                'Red Horizon',
                '4.6',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDaS1gOx_zyCf2nncKpLRb9XOiJiInGmgGlALJvS1m500mOvVBY5lSaHHEu654A--rNXNQY1HwEtJUjVEdPOKtJ_4fJdW02nqoj566S9rePO9QH-gR4MZgB75afFhzs0GhX8b2E1Ko19Ph_1YAGenI6-9qtC2yDLZlGVUjHgmyIJoGnHlWAAQMTmqGuIluyWHuYpI0uN-fRxkplgbknmS8UVTVx4m4JcPuFy1_LAsJ8q_cPwnLXS-gb5EHIQeKV06m61cNewlxog-8J',
              ),
              _buildRecommendedItem(
                'Deep Ocean Saga',
                '5.0',
                'https://lh3.googleusercontent.com/aida-public/AB6AXuDSddqpWZ7Esw7QzeLchSACG7nxGrJx-d2E_aOjrpZTCeelJZOAMBjJdbVseQiZ-Jok-wuYaIB__RbireWf0hR-aYh0dor1ICcrLxm4AKGFOXgZu28vecaV_abNAjOpXF3aih32EayDMsxKu1qscYGpeqDahClpXl1H6Mjva4SfR-pztdjb9vf5o8mtt4wXlsBV-D_5mFrrSqJ-wly0r6l-I0LmJoKRVvgccAFvUhi_sMCx-C9MKOGZH3f_nMgKifSaNeRro9rEM5e1',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedItem(String title, String rating, String imageUrl) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, color: Colors.yellow, size: 10),
                      const SizedBox(width: 2),
                      Text(
                        rating,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context, bool isDark) {
    return Positioned(
      bottom: 24,
      left: 24,
      right: 24,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          color: (isDark ? Colors.black : Colors.white).withOpacity(0.8),
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home, 'Home', true),
            _buildNavItem(Icons.auto_stories, 'Library', false),
            _buildNavItem(Icons.explore, 'Discover', false),
            _buildNavItem(Icons.more_horiz, 'More', false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? AppColors.primary : Colors.grey, size: 24),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.primary : Colors.grey,
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
