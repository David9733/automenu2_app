"""
아이콘 이미지를 조정하여 원형 마스크 안에 모든 요소가 보이도록 합니다.
원형 마스크는 보통 이미지의 약 80-85%만 보이므로, 이미지를 축소하여 중심에 배치합니다.
"""
from PIL import Image
import os

def adjust_icon_for_circle(input_path, output_path, scale_factor=0.70):
    """
    아이콘 이미지를 조정하여 원형 마스크 안에 모든 요소가 보이도록 합니다.
    원형 마스크는 중심에서 대칭적으로 잘리므로, 이미지를 축소하여 정확히 중심에 배치합니다.
    
    Args:
        input_path: 입력 이미지 경로
        output_path: 출력 이미지 경로
        scale_factor: 축소 비율 (0.70 = 70% 크기로 축소하여 중심에 배치)
    """
    # 원본 이미지 로드
    img = Image.open(input_path)
    original_size = img.size
    
    # 원본이 RGBA가 아니면 RGBA로 변환 (투명도 지원)
    if img.mode != 'RGBA':
        img = img.convert('RGBA')
    
    # 새로운 크기 계산 (원본 크기 유지)
    new_size = original_size
    
    # 축소된 이미지 크기 계산
    scaled_width = int(original_size[0] * scale_factor)
    scaled_height = int(original_size[1] * scale_factor)
    
    # 이미지 리사이즈 (고품질 리샘플링 사용)
    scaled_img = img.resize((scaled_width, scaled_height), Image.Resampling.LANCZOS)
    
    # 새로운 이미지 생성 (투명 배경)
    new_img = Image.new('RGBA', new_size, (255, 255, 255, 0))
    
    # 축소된 이미지를 정확히 중심에 배치 (대칭적으로)
    x_offset = (new_size[0] - scaled_width) // 2
    y_offset = (new_size[1] - scaled_height) // 2
    
    new_img.paste(scaled_img, (x_offset, y_offset), scaled_img)
    
    # RGB 모드로 변환 (투명도 제거, 흰색 배경)
    final_img = Image.new('RGB', new_size, (255, 255, 255))
    final_img.paste(new_img, (0, 0), new_img)
    
    # 저장
    final_img.save(output_path, 'PNG', optimize=True)
    print(f"아이콘 조정 완료: {output_path}")
    print(f"원본 크기: {original_size}, 축소 크기: ({scaled_width}, {scaled_height})")
    print(f"중심 오프셋: ({x_offset}, {y_offset})")

if __name__ == "__main__":
    input_file = "logo2.png"
    output_file = "logo2_adjusted.png"
    
    if not os.path.exists(input_file):
        print(f"오류: {input_file} 파일을 찾을 수 없습니다.")
        exit(1)
    
    # 67% 크기로 축소하여 원형을 채우면서도 시계와 술잔까지 모두 보이도록
    adjust_icon_for_circle(input_file, output_file, scale_factor=0.67)
    
    print("\n조정된 이미지를 logo2_adjusted.png로 저장했습니다.")
    print("이제 pubspec.yaml에서 logo2_adjusted.png를 사용하도록 변경하세요.")

