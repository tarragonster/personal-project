package main

import (
	"bufio"
	"context"
	"encoding/base64"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"sync"
	"time"

	"github.com/docker/docker/api/types"
	"github.com/docker/docker/api/types/filters"
	"github.com/docker/docker/client"
	"github.com/docker/docker/pkg/archive"
)

var (
	instance *client.Client
	once     = &sync.Once{}
)

func dockerClient() *client.Client {
	once.Do(func() {
		var err error
		instance, err = client.NewClientWithOpts(client.FromEnv)
		if err != nil {
			panic(err)
		}
	})
	return instance
}

func GetImage(registry, image, tag string) string {
	if registry == "" {
		return fmt.Sprintf("%s:%s", image, tag)
	} else {
		return fmt.Sprintf("%s/%s:%s", registry, image, tag)
	}
}
func ImageExisted(ctx context.Context, image string) (bool, error) {
	list, err := dockerClient().ImageList(ctx, types.ImageListOptions{
		Filters: filters.NewArgs(filters.KeyValuePair{
			Key:   "reference",
			Value: image,
		}),
	})
	if err != nil {
		return false, err
	}
	if len(list) > 0 {
		return true, nil
	}
	return false, nil
}
func ImagePull(ctx context.Context, image string, user, pass string) error {
	encodedJSON, err := json.Marshal(types.AuthConfig{
		Username: user,
		Password: pass,
	})
	if err != nil {
		return err
	}
	authStr := base64.URLEncoding.EncodeToString(encodedJSON)
	out, err := dockerClient().ImagePull(ctx, image, types.ImagePullOptions{
		RegistryAuth: authStr,
	})
	if err != nil {
		return err
	}
	if err := checkError(out); err != nil {
		return err
	}
	logger.Infof("Pull image %s successfully", image)
	return nil
}
func BuildImage(ctx context.Context, buildContext string, dockerfile string, image string) error {
	tar, err := archive.TarWithOptions(buildContext, &archive.TarOptions{})
	if err != nil {
		return err
	}
	start := time.Now()
	out, err := dockerClient().ImageBuild(ctx, tar, types.ImageBuildOptions{
		Dockerfile:  dockerfile,
		Tags:        []string{image},
		NetworkMode: "host",
	})
	if err != nil {
		return err
	}
	err = checkError(out.Body)
	if err != nil {
		return err
	}
	logger.Infof("Build image %s successfully, takes: %v seconds", image, time.Since(start).Seconds())
	return nil

}

func checkError(output io.Reader) error {
	scanner := bufio.NewScanner(output)
	for scanner.Scan() {
		line := make(map[string]interface{})
		err := json.Unmarshal(scanner.Bytes(), &line)
		if err != nil {
			return err
		}
		for k, v := range line {
			logger.Debug(k, " ", v)
		}
		if value, ok := line["errorDetail"]; ok {
			return errors.New((value.(map[string]interface{}))["message"].(string))
		}
	}
	return nil
}

func DockerLogin(ctx context.Context, username string, password string, registry string) error {
	_, err := dockerClient().RegistryLogin(ctx, types.AuthConfig{
		Username:      username,
		Password:      password,
		ServerAddress: registry,
	})
	if err != nil {
		return err
	}
	logger.Infof("Login success")
	return nil
}

func DockerPush(ctx context.Context, image string, registry string, user string, pass string) error {
	encodedJSON, err := json.Marshal(types.AuthConfig{
		Username: user,
		Password: pass,
	})
	if err != nil {
		return err
	}
	start := time.Now()
	authStr := base64.URLEncoding.EncodeToString(encodedJSON)
	out, err := dockerClient().ImagePush(ctx, image, types.ImagePushOptions{
		RegistryAuth: authStr,
	})
	if err != nil {
		return err
	}
	if err := checkError(out); err != nil {
		return err
	}
	logger.Infof("Push image %s successfully to %s, takes %v", image, registry, time.Since(start).Seconds())
	return nil
}
