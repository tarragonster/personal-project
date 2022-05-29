package main

import (
	"context"
	"flag"
	"fmt"
	"log"
	"os"
	"os/signal"
	"strings"
	"syscall"

	"github.com/sirupsen/logrus"
)

var (
	logger = logrus.New()
)

type FileSlice struct {
	List []string
}

func (FileSlice) String() string {
	return ""
}

func (f *FileSlice) Set(value string) error {
	f.List = append(f.List, strings.Split(value, ",")...)
	return nil
}
func run(ctx context.Context, dockerfile, buildContext, image, user, pass, registry string, files FileSlice) error {
	logger.Debugf("dockerfile = %s, buildContext = %s, image = %s, user = %s, pass = %s, registry = %s, files = %v", dockerfile, buildContext, image, user, pass, registry, files.List)
	hash, err := CheckHash(files.List)
	if err != nil {
		log.Fatal(err)
	}
	defer fmt.Print(hash)
	imageTag := GetImage(registry, image, hash)
	logger.Infof("Image: %v\n", imageTag)
	existed, err := ImageExisted(ctx, imageTag)
	if err != nil {
		logger.Fatal(err)
	}
	if existed {
		logger.Infof("Image existed")
		return err
	}
	logger.Infof("Image not existed")

	if err := DockerLogin(ctx, user, pass, registry); err != nil {
		logger.Fatal(err)
	}
	if err := ImagePull(ctx, imageTag, user, pass); err == nil {
		return err
	} else {
		if !strings.Contains(err.Error(), "not found") {
			log.Fatal(err)
		}
		logger.Info("Image not found")
	}

	if err := BuildImage(ctx, buildContext, dockerfile, imageTag); err != nil {
		logger.Fatal(err)
	}
	if err := DockerPush(ctx, imageTag, registry, user, pass); err != nil {
		logger.Fatal(err)
	}
	return nil
}
func main() {
	files := FileSlice{}
	dockerfile := flag.String("file", "Dockerfile", "Dockerfile")
	buildContext := flag.String("context", ".", "Build context")
	image := flag.String("image", "image", "Image name")
	user := flag.String("user", "user", "Username")
	pass := flag.String("pass", "pass", "Password")
	registry := flag.String("registry", "", "Docker registry")
	debug := flag.Bool("debug", false, "Debug mode")
	flag.Var(&files, "hash", "Files to check hash, seprate by commas")
	flag.Parse()
	if *debug {
		logger.SetLevel(logrus.DebugLevel)
	}
	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	go func() {
		ch := make(chan os.Signal, 1)
		defer close(ch)
		signal.Notify(ch, syscall.SIGTERM, syscall.SIGTERM, syscall.SIGINT)
		<-ch
		logger.Infoln("Interupted")
		cancel()
	}()

	if err := run(ctx, *dockerfile, *buildContext, *image, *user, *pass, *registry, files); err != nil {
		logger.Fatal(err)
	}

}
