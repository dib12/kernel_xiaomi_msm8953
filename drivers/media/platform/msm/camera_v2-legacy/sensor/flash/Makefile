ccflags-y += -Idrivers/media/platform/msm/camera_v2-legacy/sensor/cci
ccflags-y += -Idrivers/media/platform/msm/camera_v2-legacy
ccflags-y += -Idrivers/media/platform/msm/camera_v2-legacy/common
ccflags-y += -Idrivers/media/platform/msm/camera_v2-legacy/sensor/io
obj-$(CONFIG_MSMB_CAMERA) += msm_flash.o
obj-$(CONFIG_MSMB_CAMERA) += msm_led_flash.o
obj-$(CONFIG_MSMB_CAMERA) += msm_led_trigger.o
obj-$(CONFIG_MSMB_CAMERA) += msm_led_i2c_trigger.o
obj-$(CONFIG_MSMB_CAMERA) += adp1660.o
obj-$(CONFIG_MSMB_CAMERA) += msm_led_torch.o
ifdef CONFIG_MACH_XIAOMI_VINCE
obj-$(CONFIG_MSMB_CAMERA) += msm_frontflash.o
endif
